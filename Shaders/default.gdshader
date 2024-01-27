shader_type spatial;
render_mode  blend_mix,depth_draw_always, cull_disabled;


uniform sampler2D albedo: source_color,filter_nearest;
uniform sampler2D emission_mask: source_color,filter_nearest;
uniform vec4 emission_mask_color: source_color ;
uniform vec4 emission_color: source_color ;
uniform float alpha = 1;

void fragment() {
	vec4 albedo_texel = texture(albedo, UV);
	vec4 emission_texel = texture(emission_mask, UV);
	
	ALBEDO = albedo_texel.rgb;
	ALPHA = alpha;
	EMISSION = (emission_texel.rgb * emission_mask_color.rgb) + emission_color.rgb;
	ROUGHNESS= 1.0;
	METALLIC = 0.0;
}