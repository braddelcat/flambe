//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package flambe.platform.shader;

import flambe.platform.html.WebGLTypes;

class FillRectGL extends ShaderGL
{
    public function new (gl :RenderingContext)
    {
        super(gl,
        [ // Vertex shader
            "attribute vec2 a_pos;",
            "attribute vec3 a_rgb;",
            "attribute float a_alpha;",

            "varying vec4 v_color;",

            "void main (void) {",
                "v_color = vec4(a_rgb*a_alpha, a_alpha);",
                "gl_Position = vec4(a_pos, 0, 1);",
            "}",
        ].join("\n"),

        [ // Fragment shader
            "varying vec4 v_color;",

            "void main (void) {",
                "gl_FragColor = v_color;",
            "}",
        ].join("\n"));

        a_pos = getAttribLocation("a_pos");
        a_rgb = getAttribLocation("a_rgb");
        a_alpha = getAttribLocation("a_alpha");
    }

    override public function enableVertexArrays ()
    {
        _gl.enableVertexAttribArray(a_pos);
        _gl.enableVertexAttribArray(a_rgb);
        _gl.enableVertexAttribArray(a_alpha);

        var bytesPerFloat = 4;
        var stride = 6*bytesPerFloat;
        _gl.vertexAttribPointer(a_pos, 2, _gl.FLOAT, false, stride, 0*bytesPerFloat);
        _gl.vertexAttribPointer(a_rgb, 3, _gl.FLOAT, false, stride, 2*bytesPerFloat);
        _gl.vertexAttribPointer(a_alpha, 1, _gl.FLOAT, false, stride, 5*bytesPerFloat);
    }

    override public function disableVertexArrays ()
    {
        _gl.disableVertexAttribArray(a_pos);
        _gl.disableVertexAttribArray(a_rgb);
        _gl.disableVertexAttribArray(a_alpha);
    }

    private var a_pos :Int;
    private var a_rgb :Int;
    private var a_alpha :Int;
}