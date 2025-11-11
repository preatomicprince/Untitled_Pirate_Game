shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}


void fragment() {
	// Called for every pixel the material is visible on.
	float rand_value_x = random(UV);
	float rand_value_y = random(UV + vec2(3.456, 7.891));

	vec2 offset = vec2(sin(rand_value_x) * 0.01, cos(rand_value_y) * 0.01);

    vec2 new_uv = UV + offset;
    vec4 color = texture(TEXTURE, new_uv);
    COLOR = color;

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
