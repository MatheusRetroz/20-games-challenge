shader_type canvas_item;

uniform vec2 target_resolution = vec2(1280.0, 720.0);
uniform vec4 border_color: source_color = vec4(vec3(0.1), 1.0);
uniform sampler2D screen_texture: hint_screen_texture;

bool border(float value, float x, float y) {
	float inset = (1.0 - (x / y)) / 2.0;
	if (value < inset || value > 1.0 - inset) {
		return true;
	} return false;
}

void fragment() {
	float screen_aspect = (1.0 / SCREEN_PIXEL_SIZE.x) / (1.0 / SCREEN_PIXEL_SIZE.y);
	float target_aspect = target_resolution.x / target_resolution.y;
	
	vec2 uv = SCREEN_UV;
	bool is_border = false;
	
	if (screen_aspect > target_aspect) {
		is_border = border(uv.x, target_aspect, screen_aspect);
	} else {
		is_border = border(uv.y, screen_aspect, target_aspect);
	}
	
	COLOR = mix(texture(screen_texture, SCREEN_UV), border_color, float(is_border));
}