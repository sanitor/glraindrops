import QtQuick 2.0
import QtMultimedia 5.9

ShaderEffect {
    property vector2d dimensions: Qt.vector2d(1.0, 1.0)
    property vector2d dutyRatio: Qt.vector2d(1.0, 1.0)
    property real threshold: 0.5

    vertexShader: "
                    uniform highp mat4 qt_Matrix;
                    attribute highp vec4 qt_Vertex;
                    attribute highp vec2 qt_MultiTexCoord0;
                    varying highp vec2 coord;
                    void main() {
                        coord = qt_MultiTexCoord0;
                        gl_Position = qt_Matrix * qt_Vertex;
                    }"
    fragmentShader: "
                    varying highp vec2 coord;
                    uniform sampler2D src;
                    uniform lowp float qt_Opacity;
                    uniform highp vec2 dimensions;
                    uniform lowp float threshold;
                    uniform highp vec2 dutyRatio;
                    void main() {
                        highp vec2 pixcoord = coord * dimensions;
                        lowp bool duty = mod(pixcoord.x + pixcoord.y + 0.75, dutyRatio.x + dutyRatio.y) < dutyRatio.x;
                        lowp vec2 offset = vec2(1.0/dimensions.x, 0.0);
                        lowp vec4 tex0 = texture2D(src, coord);
                        lowp vec4 tex1 = (texture2D(src, coord - offset*2.0)
                                         +texture2D(src, coord - offset)
                                         +tex0
                                         +texture2D(src, coord + offset)
                                         +texture2D(src, coord + offset*2.0)) / 5.0;
                        lowp float y = dot(tex1.rgb, vec3(0.344, 0.5, 0.156));
                        gl_FragColor = y > threshold ? duty? vec4(0.0, 0.0, 0.0, 1.0) : tex0 : tex0;
                        //gl_FragColor = duty? vec4(1.0, 0.0, 0.0, 1.0) : tex0;
                    }"
}
