use <SectorArcModule.scad>

//You should add somme wiggle room to the measurement for the screws. Personally A little over 1mm was necessery
ScrewHeadDiameter = 5+1;
ScrewHeadThickness = 3; 
ScrewThreadDiameter = 3+1;
NutDiameter = 6 + 0.5;
NutThickness = 2.5+0.8; 

$fn = $preview ? 100 : 200; 

//Lid
translate([0,0,0])
{
    {
        length = 166;
        width = 66;
        height = 27;

        frontAngle = 50;
        backAngle = 71;
        sideAngle = 79.5;

        frontBackThickness = NutDiameter + 8;
        topThickness = 2;
        sideThickness = 2;
        difference()
        {
            translate([-0.5*width, -0.5*length, 0])
            ingot(width, length, height, frontAngle, backAngle, sideAngle);

            translate([-0.5*(width-sideThickness*2), -0.5*(length-frontBackThickness*2), -0.1])
            ingot(width-sideThickness*2, length-frontBackThickness*2, height-topThickness, frontAngle+10, backAngle, sideAngle);

            //We now make a translate to have a [0,0,0] that correspond to the corner of the top face of the ingot
            translate([-0.5*width, -0.5*length, 0])
            translate([tan(90-sideAngle)*height,tan(90-frontAngle)*height,0])
            {
                innerWidth = width - 2*(tan(90-sideAngle)*height);
                windowWidth = 47;
                //We can now confortably make the little window
                // color("red")
                translate([0.5*(innerWidth-windowWidth),10,0])
                cube([windowWidth,101,height+0.5]);
            }

            //We now make the screwholes
            translate([-0.5*width, -0.5*length, 0])
            {
                translate([0.5*NutDiameter+1, 0.5*frontBackThickness, 0])
                nutSlot(1,0);

                translate([width - 0.5*NutDiameter - 1, 0.5*frontBackThickness, 0])
                nutSlot(1,0);

                translate([0.5*NutDiameter+1, length - 0.5*frontBackThickness, 0])
                nutSlot(1,0);

                translate([width - 0.5*NutDiameter - 1, length - 0.5*frontBackThickness, 0])
                nutSlot(1,0);
            }
        }
        
        
    }
}

module nutSlot(channelBottomOfNutsHeight, channelTopOfNutsHeight )
{
    translate([0,0,-1]) cylinder(h=1 + channelBottomOfNutsHeight + NutThickness + channelTopOfNutsHeight, d=ScrewThreadDiameter); 
    translate([0,0,channelBottomOfNutsHeight]) 
    cylinder(h=NutThickness, d=NutDiameter, $fn=6);
}

module ingot(width, length, height, frontAngle, backAngle, sideAngle)
{
    difference()
        {
            cube([width, length, height]);
            //color("red")
            rotate([frontAngle,0,0])translate([-10,0,0])cube([width+20,100,100]);
            //color("blue")
            translate([0, length,0])rotate([90-backAngle,0,0])translate([-10,0,0])cube([width+20,100,100]);
            //color("blue")
            translate([0, 0,0])rotate([0,-sideAngle,0])translate([0, -10,0])cube([70,length+20,100]);
            //color("red")
            translate([width, 0,0])rotate([0,-(90-sideAngle),0])translate([0, -10,0])cube([70,length+20,100]);
        } 
}