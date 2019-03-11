
varying highp vec2 varyingCoordinate;

uniform sampler2D textureMap;
uniform lowp float brightness;

void main()
{
    lowp vec4 textureColor = texture2D(textureMap, varyingCoordinate);
    
    gl_FragColor = vec4((textureColor.rgb + vec3(brightness)), textureColor.w);
    }
