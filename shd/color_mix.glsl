extern vec4 blendColor;

vec4 effect(vec4 col, Image texture, vec2 texturePos, vec2 screenPos)
{
    vec4 textureCol = texture2D(texture, texturePos);
    vec4 color = mix(textureCol, blendColor, blendColor[3]);

    return vec4(color[0], color[1], color[2], textureCol[3]);
}
