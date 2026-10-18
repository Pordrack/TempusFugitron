//Code taken from https://openhome.cc/eGossip/OpenSCAD/SectorArc.html
globFn = 100;

module sector(radius, angles, fn = globFn) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, width = 1, fn = globFn) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
}