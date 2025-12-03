shader_type canvas_item;
render_mode blend_add;

uniform float speed = 1.0;

uniform float transparency = 0.8;

void fragment() {
	
	vec2 moving_uv = vec2(UV.x - (TIME * speed), UV.y);
	
	vec4 texture_color = texture(TEXTURE, moving_uv);
	
	COLOR = texture_color * COLOR * transparency;
}
//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
