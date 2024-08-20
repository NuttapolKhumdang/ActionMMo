shader_type canvas_item;

uniform bool active = false;

void fragment() {
	vec4 prevous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, prevous_color.a);
	vec4 new_color = prevous_color;
	if (active) {
		new_color = white_color;
	}
	COLOR = new_color;
}
