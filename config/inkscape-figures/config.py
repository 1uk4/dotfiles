def latex_template(name, title):
    return '\n'.join((r"\begin{align*}",
                      rf"    \incfig[1]{{{name}}}",
                      r"\end{align*}"))
