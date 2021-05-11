/* rng_node.h */

#ifndef RNG_NODE_H
#define RNG_NODE_H

#include "core/reference.h"
#include "scene/main/node.h"
#include "core/math/random_number_generator.h"

class RNGNode : public Node {
    GDCLASS(RNGNode, Node);

protected:
    static void _bind_methods();

private:
    RandomNumberGenerator rng_ref;

public:
    
    void set_seed(uint64_t seed);

    uint64_t get_seed();

    void set_state(uint64_t p_state);

    uint64_t get_state() const;

    void randomize();

    uint32_t randi();

    real_t randf();

    real_t randf_range(real_t from, real_t to);

    real_t randfn(real_t mean = 0.0, real_t deviation = 1.0);

    int randi_range(int from, int to);


    RNGNode();
};

#endif // RNG_NODE_H