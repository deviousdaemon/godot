/* register_types.cpp */

#include "register_types.h"

#include "core/class_db.h"
#include "rng_node.h"

void register_rng_node_types() {
    ClassDB::register_class<RNGNode>();
}

void unregister_rng_node_types() {
   // Nothing to do here in this example.
}