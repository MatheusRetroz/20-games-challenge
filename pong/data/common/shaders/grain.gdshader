shader_type canvas_item;

uniform float amount: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float size: hint_range(0.0, 100.0, 1.0) = 1.0;
uniform float alpha: hint_range(0.0, 1.0, 0.01) = 0.25;
uniform float speed: hint_range(0.0, 100.0, 0.1) = 1.0;
uniform sampler2D screen_texture: hint_screen_texture;


float random(vec2 uv) {
	return fract(sin(dot(uv.xy,vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	vec2 pixel_size = (1.0 / SCREEN_PIXEL_SIZE) / size;
	vec2 uv = floor(UV * pixel_size) / pixel_size;
	
	float time = (floor(TIME * speed) * length(UV));
	float noise = random(uv + time);
	
	color.rgb *= (noise - 0.5) * amount;
	color.a = noise * alpha;
	COLOR = clamp(color, 0.0, 1.0);
}

