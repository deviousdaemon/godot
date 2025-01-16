/**************************************************************************/
/*  collision_polygon_2d.cpp                                              */
/**************************************************************************/
/*                         This file is part of:                          */
/*                             GODOT ENGINE                               */
/*                        https://godotengine.org                         */
/**************************************************************************/
/* Copyright (c) 2014-present Godot Engine contributors (see AUTHORS.md). */
/* Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.                  */
/*                                                                        */
/* Permission is hereby granted, free of charge, to any person obtaining  */
/* a copy of this software and associated documentation files (the        */
/* "Software"), to deal in the Software without restriction, including    */
/* without limitation the rights to use, copy, modify, merge, publish,    */
/* distribute, sublicense, and/or sell copies of the Software, and to     */
/* permit persons to whom the Software is furnished to do so, subject to  */
/* the following conditions:                                              */
/*                                                                        */
/* The above copyright notice and this permission notice shall be         */
/* included in all copies or substantial portions of the Software.        */
/*                                                                        */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. */
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 */
/**************************************************************************/

#include "collision_shape_parent_2d.h"

// #include "core/math/geometry_2d.h"
#include "scene/2d/physics/area_2d.h"
#include "scene/2d/physics/collision_object_2d.h"
// #include "scene/resources/2d/concave_polygon_shape_2d.h"
// #include "scene/resources/2d/convex_polygon_shape_2d.h"

void CollisionShapeParent2D::_notification(int p_what) {
	switch (p_what) {
		case NOTIFICATION_PARENTED: {
			collision_object = Object::cast_to<CollisionObject2D>(get_parent());
			if (collision_object) {
				owner_id = collision_object->create_shape_owner(this);
				_update_in_shape_owner();
			}
		} break;

		case NOTIFICATION_ENTER_TREE: {
			if (collision_object) {
				_update_in_shape_owner();
			}
		} break;

		case NOTIFICATION_LOCAL_TRANSFORM_CHANGED: {
			if (collision_object) {
				_update_in_shape_owner(true);
			}
		} break;

		case NOTIFICATION_UNPARENTED: {
			if (collision_object) {
				collision_object->remove_shape_owner(owner_id);
			}
			owner_id = 0;
			collision_object = nullptr;
		} break;
	}
}

void CollisionShapeParent2D::_update_in_shape_owner(bool p_xform_only) {
	collision_object->shape_owner_set_transform(owner_id, get_transform());
	if (p_xform_only) {
		return;
	}
	collision_object->shape_owner_set_disabled(owner_id, disabled);
	collision_object->shape_owner_set_one_way_collision(owner_id, one_way_collision);
	collision_object->shape_owner_set_one_way_collision_margin(owner_id, one_way_collision_margin);
}

void CollisionShapeParent2D::set_disabled(bool p_disabled) {
	disabled = p_disabled;
	queue_redraw();
	if (collision_object) {
		collision_object->shape_owner_set_disabled(owner_id, p_disabled);
	}
}

bool CollisionShapeParent2D::is_disabled() const {
	return disabled;
}

void CollisionShapeParent2D::set_one_way_collision(bool p_enable) {
	one_way_collision = p_enable;
	queue_redraw();
	if (collision_object) {
		collision_object->shape_owner_set_one_way_collision(owner_id, p_enable);
	}
	update_configuration_warnings();
}

bool CollisionShapeParent2D::is_one_way_collision_enabled() const {
	return one_way_collision;
}

void CollisionShapeParent2D::set_one_way_collision_margin(real_t p_margin) {
	one_way_collision_margin = p_margin;
	if (collision_object) {
		collision_object->shape_owner_set_one_way_collision_margin(owner_id, one_way_collision_margin);
	}
}

real_t CollisionShapeParent2D::get_one_way_collision_margin() const {
	return one_way_collision_margin;
}

PackedStringArray CollisionShapeParent2D::get_configuration_warnings() const {
	PackedStringArray warnings = Node2D::get_configuration_warnings();
	
	if (one_way_collision && Object::cast_to<Area2D>(get_parent())) {
		warnings.push_back(RTR("The One Way Collision property will be ignored when the collision object is an Area2D."));
	}

	return warnings;
}

void CollisionShapeParent2D::_bind_methods() {
	
	ClassDB::bind_method(D_METHOD("set_disabled", "disabled"), &CollisionShapeParent2D::set_disabled);
	ClassDB::bind_method(D_METHOD("is_disabled"), &CollisionShapeParent2D::is_disabled);
	ClassDB::bind_method(D_METHOD("set_one_way_collision", "enabled"), &CollisionShapeParent2D::set_one_way_collision);
	ClassDB::bind_method(D_METHOD("is_one_way_collision_enabled"), &CollisionShapeParent2D::is_one_way_collision_enabled);
	ClassDB::bind_method(D_METHOD("set_one_way_collision_margin", "margin"), &CollisionShapeParent2D::set_one_way_collision_margin);
	ClassDB::bind_method(D_METHOD("get_one_way_collision_margin"), &CollisionShapeParent2D::get_one_way_collision_margin);

	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "disabled"), "set_disabled", "is_disabled");
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "one_way_collision"), "set_one_way_collision", "is_one_way_collision_enabled");
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "one_way_collision_margin", PROPERTY_HINT_RANGE, "0,128,0.1,suffix:px"), "set_one_way_collision_margin", "get_one_way_collision_margin");
}

CollisionShapeParent2D::CollisionShapeParent2D() {
	set_notify_local_transform(true);
	set_hide_clip_children(true);
}
