local function prequire(...)
	local status, lib = pcall(require, ...)
	if (status) then return lib end
	return nil
end
local ls = prequire('luasnip')
local s = ls.snippet
local ps = ls.parser.parse_snippet
local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
-- local p = require("luasnip.extras").partial
-- local m = require("luasnip.extras").match
-- local n = require("luasnip.extras").nonempty
-- local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
-- local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.conditions")

return {
    s({trig="meta", dscr={"Global Metadata", "Declarations will appear in the C++ code generated by the Faust compiler"}},
    fmta(
    [[
    declare name <quote><><quote>
    declare author <quote><><quote>
    declare copyright <quote><><quote>
    declare version <quote><><quote>
    declare license <quote><><quote>
    ]],
    {
        quote = t('"'),
        i(1, "name of plugin(s)"),
        i(2, "author name"),
        i(3, "company name"),
        i(4, "1.0.0"),
        c(5, {
            sn('BSD 3-Clause "New" or "Revised" License', {
                t("BSD-3-Clause"),i(1)
            }),
            sn("GNU General Public License v3.0 only", {
                t("GPL-3.0-only"),i(1)
            }),
            sn("MIT License", {
                t("MIT"),i(1)
            }),
            sn("The Unlicense", {
                t("Unlicense"),i(1)
            }),
            sn("GNU General Public License v3.0 or later", {
                t("GPL-3.0-or-later"),i(1)
            }),
            sn("Apache License 2.0", {
                t("Apache-2.0"),i(1)
            }),
            sn('BSD 2-Clause "Simplified" License', {
                t("BSD-2.0-Clause"),i(1)
            }),
            sn("Boost Software License 1.0", {
                t("BSL-1.0"),i(1)
            }),
            sn("Creative Commons Zero v1.0 Universal", {
                t("CC0-1.0"),i(1)
            }),
            sn("GNU General Public License v2.0 only", {
                t("GPL-2.0-only"),i(1)
            }),
            sn("GNU Lesser General Public License v3.0 or later", {
                t("LGPL-3.0-or-later"),i(1)
            }),
            sn("GNU Affero General Public License v3.0 or later", {
                t("AGPL-3.0-or-later"),i(1)
            }),
            sn("Mozilla Public License 2.0", {
                t("MPL-2.0"),i(1)
            }),
            sn("Eclipse Public License 2.0", {
                t("EPL-2.0"),i(1)
            }),
            sn("Do What The F*ck You Want To Public License v3.1", {
                t("WTFPL"),i(1)
            }),
            sn("insert", {
                i(1, "???")
            })
        })
    })
    ),

	s({trig="import", dscr="File imports allow us to import definitions from other source files."}, t("import(\""), i(1, "stdfaust"), t(".lib\")")),

	s({trig="hslider", dscr={
        [[
        The hslider primitive implements a horizontal slider.
        Category: Language Primitive
        label: the label (expressed as a string) of the element in the interface
        init: the initial value of the slider, a constant numerical expression
        min: the minimum value of the slider, a constant numerical expression
        max: the maximum value of the slider, a constant numerical expression
        step: the precision (step) of the slider (1 to count 1 by 1, 0.1 to count 0.1 by 0.1, etc.), a constant numerical expression
        ]]
    }},
    fmt('hslider("{name}",{},{},{},{})',
    {
        name = i(1, "gain"),
        i(2, "0.5"),
        i(3, "0.0"),
        i(4, "1.0"),
        i(5, "0.1")
    })
    ),
    -- TODO:() create hsl alias..

	s({trig="vslider", dscr={
        [[
        The vslider primitive implements a vertical slider.
        Category: Language Primitive
        label: the label (expressed as a string) of the element in the interface
        init: the initial value of the slider, a constant numerical expression
        min: the minimum value of the slider, a constant numerical expression
        max: the maximum value of the slider, a constant numerical expression
        step: the precision (step) of the slider (1 to count 1 by 1, 0.1 to count 0.1 by 0.1, etc.), a constant numerical expression
        ]]
    }},
    fmt('vslider("{name}",{},{},{},{})',
    {
        name = i(1, "gain"),
        i(2, "0.5"),
        i(3, "0.0"),
        i(4, "1.0"),
        i(5, "0.1")
    })
    ),
    -- TODO:() create vsl alias..

    -- TODO:() create slider choice-type snippet with "sn" hslider/vslider

    -- Delays
    ps({trig="sdelay", dscr={
        [[
        s(mooth)delay: a mono delay that doesn't click and doesn't transpose when the delay time is changed.

        Usage
        _ : sdelay(n,it,dt) : _
        Where :
        n: the max delay length in samples
        it: interpolation time (in samples) for example 1024
        dt: delay time (in samples)
        ]]
    }}, "de.sdelay(${1:maxdelay},${2:interptime},${3:delaytime})"),

    ps({trig="fdelay", dscr={
        [[
        Simple `d` samples fractional delay based on 2 interpolated delay lines where n is the maximum delay length as a number of samples. fdelay is a standard Faust function.

        Usage
        _ : fdelay(n,d) : _
        Where:

        n: the max delay length in samples
        d: the delay length as a number of samples (float)
        ]]
        }}, "de.fdelay(${1:maxdelay},${2:delaytime})"),

    ps({trig="delay", dscr={
        [[
        Simple `d` samples delay where n is the maximum delay length as a number of samples. Unlike the @ delay operator, here the delay signal d is explicitly bounded to the interval [0..n]. The consequence is that delay will compile even if the interval of d can't be computed by the compiler. delay is a standard Faust function.

        Usage
        _ : delay(n,d) : _
        Where:

        n: the max delay length in samples
        d: the delay length as a number of samples (integer)
        ]]
        }}, "de.delay(${1:maxdelay},${2:delaytime})"),

    ps({trig="fdelayltv", dscr={
        [[
        Fractional delay line using Lagrange interpolation.

        Usage
        _ : fdelaylt[i|v](order, maxdelay, delay, inputsignal) : _
        Where order=1,2,3,... is the order of the Lagrange interpolation polynomial.

        fdelaylti is most efficient, but designed for constant/slowly-varying delay. fdelayltv is more expensive and more robust when the delay varies rapidly.

        NOTE: The requested delay should not be less than (order-1)/2.
        ]]
        }}, "de.fdelayltv(${1:order},${2:maxdelay}, ${3:delay}, ${4:inputsignal})"),

    ps({trig="fdelaylti", dscr={
        [[
        Fractional delay line using Lagrange interpolation.

        Usage
        _ : fdelaylt[i|v](order, maxdelay, delay, inputsignal) : _
        Where order=1,2,3,... is the order of the Lagrange interpolation polynomial.

        fdelaylti is most efficient, but designed for constant/slowly-varying delay. fdelayltv is more expensive and more robust when the delay varies rapidly.

        NOTE: The requested delay should not be less than (order-1)/2.
        ]]
        }}, "de.fdelaylti(${1:order},${2:maxdelay}, ${3:delay}, ${4:inputsignal})"),

    s({trig="fdelayn", dscr={
        [[
        For convenience, fdelay1, fdelay2, fdelay3, fdelay4, fdelay5 are also available where n is the order of the interpolation.

        Thiran Allpass Interpolation

        Reference
            https://ccrma.stanford.edu/~jos/pasp/Thiran_Allpass_Interpolators.html
        ]]
        }},
        fmt("{}",
        {
            c(1, {
                sn('inperp 1', {
                    t("de.fdelay1"),i(1)
                }),
                sn('inperp 2', {
                    t("de.fdelay2"),i(1)
                }),
                sn('inperp 3', {
                    t("de.fdelay3"),i(1)
                }),
                sn('inperp 4', {
                    t("de.fdelay4"),i(1)
                }),
                sn('inperp 5', {
                    t("de.fdelay5"),i(1)
                })
            })
        })
        ),

    ps({trig="fdelayna", dscr={
        [[
        Delay lines interpolated using Thiran allpass interpolation.

        Usage
        _ : fdelay[N]a(maxdelay, delay, inputsignal) : _
        (exactly like fdelay)

        Where:
        N=1,2,3, or 4 is the order of the Thiran interpolation filter, and the delay argument is at least N - 1/2.
        Note
        The interpolated delay should not be less than N - 1/2. (The allpass delay ranges from N - 1/2 to N + 1/2.) This constraint can be alleviated by altering the code, but be aware that allpass filters approach zero delay by means of pole-zero cancellations. The delay range [N-1/2,N+1/2] is not optimal. What is?

        Delay arguments too small will produce an UNSTABLE allpass!

        Because allpass interpolation is recursive, it is not as robust as Lagrange interpolation under time-varying conditions (You may hear clicks when changing the delay rapidly.)

        First-order allpass interpolation, delay d in [0.5,1.5]
        ]]
        }}, "de.fdelay[${1:N}]a(${2:maxdelay}, ${3:delay}, ${4:inputsignal})"),

        -- Primitives
    s({trig="route", dscr={
        "The route primitive facilitates the routing of signals in Faust. It has the following syntax:",
        "route(A,B,a,b,c,d,...)",
        "route(A,B,(a,b),(c,d),...)",
        "where:",
        "A is the number of input signals, as a constant numerical expression",
        "B is the number of output signals, as a constant numerical expression",
        "a,b / (a,b) is an input/output pair, as constant numerical expressions",
        "Inputs are numbered from 1 to A and outputs are numbered from 1 to B. There can be any number of input/output pairs after the declaration of A and B.",
        "",
        "For example, crossing two signals can be carried out with: `process = route(2,2,1,2,2,1);`",
        "In that case, route has 2 inputs and 2 outputs. The first input (1) is connected to the second output (2) and the second input (2) is connected to the first output (1).",
        "",
        "Note that parenthesis can be optionally used to define a pair, so the previous example can also be written as: `process = route(2,2,(1,2),(2,1));`",
        "More complex expressions can be written using algorithmic constructions, like the following one to cross N signals:",
        "```",
        "// cross 10 signals:",
        "// input 0 -> output 10",
        "// input 1 -> output 9",
        "// ...",
        "// input 9 -> output 0",
        "",
        "N = 10;",
        "r = route(N,N,par(i,N,(i+1,N-i)));",
        "",
        "process = r;",
        "```"
    }}, {
        c(1, {
            sn("route with par iteration",
            fmta("route(<N>, <>, par(i,<>,(i+1,<>-i)));",
            {
                N = i(1, "5"),
                rep(1),
                rep(1),
                rep(1)
            })
            ),
            sn("route pairs",
            fmta("route(<>, <>, (<>, <>), (<>, <>)<>);",
            {
                i(1, "2"),
                i(2, "2"),
                i(3, "1"),
                i(4, "2"),
                i(5, "2"),
                i(6, "1"),
                i(7, ", ..."),
            })
            )
        })
    }),
    -- TODO:() create a dynamic_node snippet for route -> size of ins and outs

    -- Spat
    ps({trig="pan", dscr={
        [[
        A simple linear stereo panner. panner is a standard Faust function.

        Usage
        _ : panner(g) : _,_

        Where:
        g: the panning (0-1)
        ]]
    }}, "sp.panner(${1:pan})"),

    ps({trig="spat", dscr={
        [[
        GMEM SPAT: n-outputs spatializer. spat is a standard Faust function.

        Usage
        _ : spat(n,r,d) : _,_,...
        Where:

        n: number of outputs
        r: rotation (between 0 et 1)
        d: distance of the source (between 0 et 1)
        ]]
    }}, "sp.spat(${1:number of outputs}, ${2:rotation}, ${3:distance})"),

    ps({trig="stereoize", dscr={
        [[
        (sp.)stereoize
        Transform an arbitrary processor p into a stereo processor with 2 inputs and 2 outputs.

        Usage
        _,_ : stereoize(p) : _,_

        Where:
        p: the arbitrary processor
        ]]
    }}, "sp.stereoize(${1:p})"),

    -- Iterations
    ps({trig="par", dscr={
        "The par iteration can be used to duplicate an expression in parallel. Just like other types of iterations in Faust:",
        "",
        "its first argument is a variable name containing the number of the current iteration (a bit like the variable that is usually named i in a for loop) starting at 0,",
        "its second argument is the number of iterations,",
        "its third argument is the expression to be duplicated."
    }},
    "par(${1:i},${2:numIterations},${3:expression($1)})"),
    ps({trig="seq", dscr={
        "The seq iteration can be used to duplicate an expression in series. Just like other types of iterations in Faust:",
        "",
        "its first argument is a variable name containing the number of the current iteration (a bit like the variable that is usually named i in a for loop) starting at 0,",
        "its second argument is the number of iterations,",
        "its third argument is the expression to be duplicated."
    }},
    "seq(${1:i},${2:numIterations},${3:expression($1)})"),
    ps({trig="sum", dscr={
        "The sum iteration can be used to duplicate an expression as a sum. Just like other types of iterations in Faust:",
        "",
        "its first argument is a variable name containing the number of the current iteration (a bit like the variable that is usually named i in a for loop) starting at 0,",
        "its second argument is the number of iterations,",
        "its third argument is the expression to be duplicated."
    }},
    "sum(${1:i},${2:numIterations},${3:expression($1)})"),
    ps({trig="prod", dscr={
        "The prod iteration can be used to duplicate an expression as a product. Just like other types of iterations in Faust:",
        "",
        "its first argument is a variable name containing the number of the current iteration (a bit like the variable that is usually named i in a for loop) starting at 0,",
        "its second argument is the number of iterations,",
        "its third argument is the expression to be duplicated."
    }},
    "prod(${1:i},${2:numIterations},${3:expression($1)})"),

    -- Environment Expressions
	s({trig="with", dscr={
        "The with construction allows to specify a local environment: a private list of definition that will be used to evaluate the left hand expression.",
        "",
        "example :",
        "```",
        "pink = f : + ~ g",
        "with {",
        "  f(x) = 0.04957526213389*x - 0.06305581334498*x' + 0.01483220320740*x'';",
        "  g(x) = 1.80116083982126*x - 0.80257737639225*x';",
        "};",
        "process = pink;",
        "```",
        "",
        "the definitions of f(x) and g(x) are local to f : + ~ g.",
        "",
        "Please note that with is left associative and has the lowest priority:",
        "`f : + ~ g with {...}` is equivalent to `(f : + ~ g) with {...}`.",
        "`f : + ~ g with {...} with {...}` is equivalent to `((f : + ~ g) with {...}) with {...}`."
    }}, {
        t("with {"), i(1, "???"), t("};")
    }),
	s({trig="letrec", dscr={
        "The letrec construction is somehow similar to with, but for difference equations instead of regular definitions. It allows us to easily express groups of mutually recursive signals, for example:",
        "x(t)=y(t−1)+10y  (t)=x(t−1)−1",
        "as `E letrec { 'x = y+10; 'y = x-1; }`",
        "Note the special notation 'x = y + 10 instead of x = y' + 10. It makes syntactically impossible to write non-sensical equations like x=x+1.",
        "",
        "Here is a more involved example. Let say we want to define an envelope generator with an attack and a release time (as a number of samples), and a gate signal. A possible definition could be:",
        "",
        "example :",
        "```",
        'import("stdfaust.lib");',
        "ar(a,r,g) = v",
        "letrec {",
            "  'n = (n+1) * (g<=g');",
            "  'v = max(0, v + (n<a)/a - (n>=a)/r) * (g<=g');",
        "};",
        'gate = button("gate");',
        "process = os.osc(440)*ar(1000,1000,gate);",
        "```",
        "",
        "With the following semantics for n(t) and v(t):",
        "n(t)=(n(t−1)+1)∗(g(t)<=g(t−1))",
        "v(t)=max(0,v(t−1)+(n(t−1)<a(t))/a(t)−(n(t−1)>=a(t))/r(t))∗(g(t)<=g(t−1))"
    }}, {
        t("letrec {"), i(1, "???"), t("};")
    }),
	s({trig="environment", dscr="The environment construction allows to create an explicit environment. It is like a `with', but without the left hand expression. It is a convenient way to group together related definitions, to isolate groups of definitions and to create a name space hierarchy."}, {
        i(1, "constant"), t(" = environment {"), i(2, "???"), t("};")
    })
    -- TODO:() create env alias snippet..
}