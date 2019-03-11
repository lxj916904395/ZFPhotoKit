
attribute vec4 position;//顶点位置
attribute vec2 textureCoordinate;//纹理坐标

varying lowp vec2 varyingCoordinate;

void main(){
    varyingCoordinate = textureCoordinate;
    gl_Position = position;
}
