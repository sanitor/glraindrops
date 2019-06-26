import QtQuick 2.0
import QtMultimedia 5.9

ShaderEffect {
    property vector2d dimensions: Qt.vector2d(1.0, 1.0)
    property real threshold: 0.5
    property color lineColor: Qt.rgba(1.0, 0.0, 0.0, 1.0)

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
                    uniform lowp vec4 lineColor;
                    void main() {
                        highp vec2 pixcoord = coord * dimensions;
                        lowp vec2 offset = vec2(1.0/dimensions.x, 0.0);
                        lowp vec4 tex0 = texture2D(src, coord - offset*2.0);
                        lowp vec4 tex1 = texture2D(src, coord - offset);
                        lowp vec4 tex2 = texture2D(src, coord);
                        lowp vec4 tex3 = texture2D(src, coord + offset);
                        lowp vec4 tex4 = texture2D(src, coord + offset*2.0);
                        lowp float hf0 = dot(abs(tex0.rgb - tex2.rgb), vec3(1.0));
                        lowp float hf1 = dot(abs(tex1.rgb - tex3.rgb), vec3(1.0));
                        lowp float hf2 = dot(abs(tex2.rgb - tex4.rgb), vec3(1.0));
                        lowp float energy = (hf0 + hf1 + hf2) * 0.3;
                        gl_FragColor = energy > threshold ? lineColor : tex2;
                    }"
}
