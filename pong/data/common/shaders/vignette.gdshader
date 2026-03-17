shader_type canvas_item;

uniform float vignette_intensity = 0.4;
uniform float vignette_alpha: hint_range(0.0, 1.0) = 0.5;
uniform vec4 vignette_color: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float blur_intensity: hint_range(0.0, 5.0, 0.1) = 2.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;


float vignette(vec2 uv){
	uv *= 1.0 - uv.xy;
	return pow(uv.x * uv.y, vignette_intensity * vignette_alpha);
}

void fragment(){
	vec4 screen_texture = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_intensity);
	vec4 vignette_texture = texture(TEXTURE, UV);
	vignette_texture *= (1.0 - vignette(UV));
	
	vec4 color = mix(screen_texture, vignette_color, vignette_texture);
	COLOR = color;
}
