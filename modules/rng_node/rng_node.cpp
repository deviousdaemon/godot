/* rng_node.cpp */

#include "rng_node.h"

void RNGNode::set_seed(uint64_t seed) {
	rng_ref.set_seed(seed);
}

uint64_t RNGNode::get_seed() {
	return rng_ref.get_seed();
}

void RNGNode::set_state(uint64_t p_state) {
	rng_ref.set_state(p_state);
}

uint64_t RNGNode::get_state() const {
	return rng_ref.get_state();
}

void RNGNode::randomize() {
	rng_ref.randomize();
}

uint32_t RNGNode::randi() {
	return rng_ref.randi();
}

real_t RNGNode::randf() {
	return rng_ref.randf();
}

real_t RNGNode::randf_range(real_t from, real_t to) {
	return rng_ref.randf_range(from, to);
}

real_t RNGNode::randfn(real_t mean, real_t deviation) {
	return rng_ref.randfn(mean, deviation);
}

int RNGNode::randi_range(int from, int to) {
	return rng_ref.randi_range(from, to);
}

void RNGNode::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_seed", "seed"), &RNGNode::set_seed);
    ClassDB::bind_method(D_METHOD("get_seed"), &RNGNode::get_seed);
    ClassDB::bind_method(D_METHOD("set_state", "p_state"), &RNGNode::set_state);
    ClassDB::bind_method(D_METHOD("get_state"), &RNGNode::get_state);
    ClassDB::bind_method(D_METHOD("randomize"), &RNGNode::randomize);
    ClassDB::bind_method(D_METHOD("randi"), &RNGNode::randi);
    ClassDB::bind_method(D_METHOD("randf"), &RNGNode::randf);
    ClassDB::bind_method(D_METHOD("randf_range", "from", "to"), &RNGNode::randf_range);
    ClassDB::bind_method(D_METHOD("randfn", "mean", "deviation"), &RNGNode::randfn, DEFVAL(0.0f), DEFVAL(1.0f));
    ClassDB::bind_method(D_METHOD("randi_range", "from", "to"), &RNGNode::randi_range);
}

RNGNode::RNGNode() {
}