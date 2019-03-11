
varying highp vec2 varyingCoordinate;
uniform sampler2D textureMap;
uniform highp float exposure;

void main()
{
    highp vec4 textureColor = texture2D(textureMap, varyingCoordinate);
    
    gl_FragColor = vec4(textureColor.rgb * pow(2.0, exposure), textureColor.w);
}
