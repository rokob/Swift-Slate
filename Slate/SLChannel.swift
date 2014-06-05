//  Copyright (c) 2014 rokob. All rights reserved.

import Foundation

class Channel<T> {
  typealias ValueType = T

  var inbox: T[]
  var outbox: T[]
  var queue: dispatch_queue_t
  var inboxSemaphore: dispatch_semaphore_t
  var outboxSemaphore: dispatch_semaphore_t
  var buffer: Int

  convenience init() {
    self.init(buffer: 0)
  }

  init(buffer: Int) {
    inbox = []
    outbox = []
    self.buffer = buffer
    var attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, 0, 0)
    queue = dispatch_queue_create(__FILE__, attr)
    inboxSemaphore = dispatch_semaphore_create(buffer)
    outboxSemaphore = dispatch_semaphore_create(0)
  }

  func send(value: T) {
    switch buffer {
    case 0:
      dispatch_sync(queue) {
        self.inbox.append(value)
        if self.inbox.count == 1 {
          dispatch_semaphore_signal(self.inboxSemaphore)
        }
      }
      dispatch_semaphore_wait(self.outboxSemaphore, DISPATCH_TIME_FOREVER)
    default:
      dispatch_async(queue) {
        self.inbox.append(value)
        dispatch_semaphore_signal(self.inboxSemaphore)
      }
    }
  }

  func receive() -> T? {
    var result: T?
    dispatch_semaphore_signal(outboxSemaphore)
    while !result {
      dispatch_sync(queue) {
        if self.outbox.isEmpty {
          if self.inbox.isEmpty {
            result = nil
          } else {
            self.outbox = self.inbox.reverse()
            self.inbox = []
          }
        }
        if !self.outbox.isEmpty {
          result = self.outbox.removeLast()
        }
      }
      if !result {
        dispatch_semaphore_wait(inboxSemaphore, DISPATCH_TIME_FOREVER)
      }
    }
    return result
  }
}

operator infix <- {}
operator prefix <- {}

@prefix func <-<T>(channel: Channel<T>) -> T? {
  return channel.receive()
}

@infix func <-<T>(channel: Channel<T>, value: T) {
  channel.send(value)
}

func go(function: () -> ()) {
  dispatch_async(dispatch_get_global_queue(0, 0), function)
}

func goingSwiftly() {

  var channel = Channel<Int>()

  go {
    if let theInt = <-channel {
      println("Got \(theInt)")
    }
  }

  go {
    channel <- 4
  }

}
