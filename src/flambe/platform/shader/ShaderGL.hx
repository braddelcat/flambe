//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package flambe.platform.shader;

import flambe.platform.html.WebGLTypes;
import flambe.util.Assert;

/**
 * Since there's no HxSL GLSL compiler (yet?), all GL shaders extend this.
 */
class ShaderGL
{
    public function new (gl :RenderingContext, vertSource :String, fragSource :String)
    {
        // Prepend the required precision rigamarole
        fragSource = [
            "#ifdef GL_ES",
                "precision highp float;",
            "#endif",
        ].join("\n") + "\n" + fragSource;

        _gl = gl;
        _program = gl.createProgram();
        gl.attachShader(_program, createShader(gl, gl.VERTEX_SHADER, vertSource));
        gl.attachShader(_program, createShader(gl, gl.FRAGMENT_SHADER, fragSource));
        gl.linkProgram(_program);

#if debug
        if (!gl.getProgramParameter(_program, gl.LINK_STATUS)) {
            Log.error("Error linking shader program", ["log", gl.getProgramInfoLog(_program)]);
        }
#end
    }

    public function useProgram ()
    {
        _gl.useProgram(_program);
    }

    public function enableVertexArrays ()
    {
        Assert.fail("abstract");
    }

    public function disableVertexArrays ()
    {
        Assert.fail("abstract");
    }

    private function getAttribLocation (name :String) :Int
    {
        var loc = _gl.getAttribLocation(_program, name);
        Assert.that(loc >= 0, "Missing attribute", ["name", name]);
        return loc;
    }

    private function getUniformLocation (name :String) :UniformLocation
    {
        var loc = _gl.getUniformLocation(_program, name);
        Assert.that(loc != null, "Missing uniform", ["name", name]);
        return loc;
    }

    private static function createShader (gl :RenderingContext, type :Int, source :String) :Shader
    {
        var shader = gl.createShader(type);
        gl.shaderSource(shader, source);
        gl.compileShader(shader);

#if debug
        if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
            var typeName = (type == gl.VERTEX_SHADER) ? "vertex" : "fragment";
            Log.error("Error compiling " + typeName + " shader", [
                "log", gl.getShaderInfoLog(shader)]);
        }
#end
        return shader;
    }

    private var _gl :RenderingContext;
    private var _program :Program;
}
