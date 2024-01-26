shader_type spatial;
render_mode blend_add,unshaded,cull_disabled;

uniform sampler2D flipbook_texture: source_color,filter_nearest;
uniform int frame_count = 15;
uniform int frame_index = 2;


vec2 flipbook(vec2 uv, vec2 size, float progress){
	progress = floor( mod(progress, (size.x * size.y)) );
	vec2 frame_size = vec2(1.0, 1.0) / vec2(size.x, size.y);
	vec2 frame = fract(uv / size) + frame_size;
	
	frame.x += ( (progress / size.x) - frame_size.x * floor(progress/size.x) * size.x ) - frame_size.x;
	frame.y += (frame_size.y * floor(progress/size.x) ) - frame_size.y;
	
	
	return frame;
}

void fragment()
{
	
	vec2 flip_uv = flipbook(UV, vec2(3.0, 1.0), float(TIME * 10.));//);
	vec4 texel = texture(flipbook_texture, flip_uv);
	ALBEDO = texel.rgb;
	EMISSION = texel.rgb;
	ALBEDO -= FOG.rgb;
}
