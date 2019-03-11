
varying lowp vec2 varyingCoordinate;
uniform sampler2D textureMap;

void main(){
    gl_FragColor = texture2D(textureMap,varyingCoordinate);
}
