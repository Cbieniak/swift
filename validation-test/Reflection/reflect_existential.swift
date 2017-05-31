// RUN: rm -rf %t && mkdir -p %t
// RUN: %target-build-swift -lswiftSwiftReflectionTest %s -o %t/reflect_existential
// RUN: %target-run %target-swift-reflection-test %t/reflect_existential 2>&1 | %FileCheck %s --check-prefix=CHECK-%target-ptrsize
// REQUIRES: objc_interop
// REQUIRES: executable_test

import SwiftReflectionTest

class TestGeneric<T> {
  var t: T

  init(_ t: T) {
    self.t = t
  }
}

protocol P {}
protocol CP : class {}
class C : CP {}
class D : C, P {}

reflect(object: TestGeneric(D() as Any))

// CHECK-64: Type reference:
// CHECK-64: (bound_generic_class reflect_existential.TestGeneric
// CHECK-64:   (protocol_composition))

// CHECK-64: Type info:
// CHECK-64: (class_instance size=48 alignment=8 stride=48 num_extra_inhabitants=0
// CHECK-64:   (field name=t offset=16
// CHECK-64:     (opaque_existential size=32 alignment=8 stride=32 num_extra_inhabitants=0
// CHECK-64:       (field name=metadata offset=24
// CHECK-64:         (builtin size=8 alignment=8 stride=8 num_extra_inhabitants=2147483647)))))

// CHECK-32: Type reference:
// CHECK-32: (bound_generic_class reflect_existential.TestGeneric
// CHECK-32:   (protocol_composition))

// CHECK-32: Type info:
// CHECK-32: (class_instance size=28 alignment=4 stride=28 num_extra_inhabitants=0
// CHECK-32:   (field name=t offset=12
// CHECK-32:     (opaque_existential size=16 alignment=4 stride=16 num_extra_inhabitants=0
// CHECK-32:       (field name=metadata offset=12
// CHECK-32:         (builtin size=4 alignment=4 stride=4 num_extra_inhabitants=4096)))))

reflect(object: TestGeneric(D() as P))

// CHECK-64: Type reference:
// CHECK-64: (bound_generic_class reflect_existential.TestGeneric
// CHECK-64:   (protocol_composition
// CHECK-64:     (protocol reflect_existential.P)))

// CHECK-64: Type info:
// CHECK-64: (class_instance size=56 alignment=8 stride=56 num_extra_inhabitants=0
// CHECK-64:   (field name=t offset=16
// CHECK-64:     (opaque_existential size=40 alignment=8 stride=40 num_extra_inhabitants=0
// CHECK-64:       (field name=metadata offset=24
// CHECK-64:         (builtin size=8 alignment=8 stride=8 num_extra_inhabitants=2147483647))
// CHECK-64:       (field name=wtable offset=32
// CHECK-64:         (builtin size=8 alignment=8 stride=8 num_extra_inhabitants=1)))))

// CHECK-32: Type reference:
// CHECK-32: (bound_generic_class reflect_existential.TestGeneric
// CHECK-32:   (protocol_composition
// CHECK-32:     (protocol reflect_existential.P)))

// CHECK-32: Type info:
// CHECK-32: (class_instance size=32 alignment=4 stride=32 num_extra_inhabitants=0
// CHECK-32:   (field name=t offset=12
// CHECK-32:     (opaque_existential size=20 alignment=4 stride=20 num_extra_inhabitants=0
// CHECK-32:       (field name=metadata offset=12
// CHECK-32:         (builtin size=4 alignment=4 stride=4 num_extra_inhabitants=4096))
// CHECK-32:       (field name=wtable offset=16
// CHECK-32:         (builtin size=4 alignment=4 stride=4 num_extra_inhabitants=1)))))

reflect(object: TestGeneric(D() as (P & AnyObject)))

// CHECK-64: Type reference:
// CHECK-64: (bound_generic_class reflect_existential.TestGeneric
// CHECK-64:   (protocol_composition any_object
// CHECK-64:     (protocol reflect_existential.P)))

// CHECK-64: Type info:
// CHECK-64: (class_instance size=32 alignment=8 stride=32 num_extra_inhabitants=0
// CHECK-64:   (field name=t offset=16
// CHECK-64:     (class_existential size=16 alignment=8 stride=16 num_extra_inhabitants=2147483647
// CHECK-64:       (field name=object offset=0
// CHECK-64:         (reference kind=strong refcounting=unknown))
// CHECK-64:       (field name=wtable offset=8
// CHECK-64:         (builtin size=8 alignment=8 stride=8 num_extra_inhabitants=1)))))

// CHECK-32: Type reference:
// CHECK-32: (bound_generic_class reflect_existential.TestGeneric
// CHECK-32:   (protocol_composition any_object
// CHECK-32:     (protocol reflect_existential.P)))

// CHECK-32: Type info:
// CHECK-32: (class_instance size=20 alignment=4 stride=20 num_extra_inhabitants=0
// CHECK-32:   (field name=t offset=12
// CHECK-32:     (class_existential size=8 alignment=4 stride=8 num_extra_inhabitants=4096
// CHECK-32:       (field name=object offset=0
// CHECK-32:         (reference kind=strong refcounting=unknown))
// CHECK-32:       (field name=wtable offset=4
// CHECK-32:         (builtin size=4 alignment=4 stride=4 num_extra_inhabitants=1)))))

reflect(object: TestGeneric(D() as CP))

// CHECK-64: Type reference:
// CHECK-64: (bound_generic_class reflect_existential.TestGeneric
// CHECK-64:   (protocol_composition any_object
// CHECK-64:     (protocol reflect_existential.CP)))

// CHECK-64: Type info:
// CHECK-64: (class_instance size=32 alignment=8 stride=32 num_extra_inhabitants=0
// CHECK-64:   (field name=t offset=16
// CHECK-64:     (class_existential size=16 alignment=8 stride=16 num_extra_inhabitants=2147483647
// CHECK-64:       (field name=object offset=0
// CHECK-64:         (reference kind=strong refcounting=unknown))
// CHECK-64:       (field name=wtable offset=8
// CHECK-64:         (builtin size=8 alignment=8 stride=8 num_extra_inhabitants=1)))))

// CHECK-32: Type reference:
// CHECK-32: (bound_generic_class reflect_existential.TestGeneric
// CHECK-32:   (protocol_composition any_object
// CHECK-32:     (protocol reflect_existential.CP)))

// CHECK-32: Type info:
// CHECK-32: (class_instance size=20 alignment=4 stride=20 num_extra_inhabitants=0
// CHECK-32:   (field name=t offset=12
// CHECK-32:     (class_existential size=8 alignment=4 stride=8 num_extra_inhabitants=4096
// CHECK-32:       (field name=object offset=0
// CHECK-32:         (reference kind=strong refcounting=unknown))
// CHECK-32:       (field name=wtable offset=4
// CHECK-32:         (builtin size=4 alignment=4 stride=4 num_extra_inhabitants=1)))))

reflect(object: TestGeneric(D() as (C & P)))

// CHECK-64: Type reference:
// CHECK-64: (bound_generic_class reflect_existential.TestGeneric
// CHECK-64:   (protocol_composition any_object
// CHECK-64:     (class reflect_existential.C)
// CHECK-64:     (protocol reflect_existential.P)))

// CHECK-64: Type info:
// CHECK-64: (class_instance size=32 alignment=8 stride=32 num_extra_inhabitants=0
// CHECK-64:   (field name=t offset=16
// CHECK-64:     (class_existential size=16 alignment=8 stride=16 num_extra_inhabitants=2147483647
// CHECK-64:       (field name=object offset=0
// CHECK-64:         (reference kind=strong refcounting=native))
// CHECK-64:       (field name=wtable offset=8
// CHECK-64:         (builtin size=8 alignment=8 stride=8 num_extra_inhabitants=1)))))

// CHECK-32: Type reference:
// CHECK-32: (bound_generic_class reflect_existential.TestGeneric
// CHECK-32:   (protocol_composition any_object
// CHECK-32:     (class reflect_existential.C)
// CHECK-32:     (protocol reflect_existential.P)))

// CHECK-32: Type info:
// CHECK-32: (class_instance size=20 alignment=4 stride=20 num_extra_inhabitants=0
// CHECK-32:   (field name=t offset=12
// CHECK-32:     (class_existential size=8 alignment=4 stride=8 num_extra_inhabitants=4096
// CHECK-32:       (field name=object offset=0
// CHECK-32:         (reference kind=strong refcounting=native))
// CHECK-32:       (field name=wtable offset=4
// CHECK-32:         (builtin size=4 alignment=4 stride=4 num_extra_inhabitants=1)))))

doneReflecting()

// CHECK-64: Done.

// CHECK-32: Done.
