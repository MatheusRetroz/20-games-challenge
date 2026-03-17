shader_type canvas_item;

uniform bool enable = false;
uniform vec4 color: source_color = vec4(0.871, 0.823, 0.896, 1.0);
uniform float shake_speed: hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float shake_intensity = 10.0;


float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453);
}

vec2 shake(vec2 uv, float time) {
	float value = (floor(time * (100.0 * shake_speed)) * length(uv));
	vec2 random_offset = vec2(
		random(vec2(value, 0.0)) * 2.0 - 1.0,
		random(vec2(value, 100.0)) * 2.0 - 1.0
		);
	return random_offset * shake_intensity;
}

void vertex() {
	if (enable) {
		VERTEX += shake(UV, TIME);
	}
}

void fragment() {
	if (enable) {
		COLOR.rgb = color.rgb;
	}
}

