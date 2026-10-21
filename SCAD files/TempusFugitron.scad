use <SectorArcModule.scad>

//You should add somme wiggle room to the measurement for the screws. Personally A little over 1mm was necessery
ScrewHeadDiameter = 5+1;
ScrewHeadThickness = 3; 
ScrewThreadDiameter = 3+1;
NutDiameter = 6 + 0.5;
NutThickness = 2.5+0.8; 

$fn = $preview ? 100 : 200; 

GenerateInOnePiece = true;

lidLength = 166;
lidWidth = 66;
lidSupportThickness = 4.7;

//Top part
if(false)
{
    height = 27;

    frontAngle = 50;
    backAngle = 71;
    sideAngle = 79.5;

    frontBackThickness = NutDiameter + 8;
    topThickness = 3;
    sideThickness = 3;

    //Lid
    translate([0,0,0])
    translate([0.5*lidWidth, 0.5*lidLength, 0])
    {
        difference()
        {
            translate([-0.5*lidWidth, -0.5*lidLength, 0])
            ingot(lidWidth, lidLength, height, frontAngle, backAngle, sideAngle, sideAngle);

            translate([-0.5*(lidWidth-sideThickness*2), -0.5*(lidLength-frontBackThickness*2), -0.1])
            ingot(lidWidth-sideThickness*2, lidLength-frontBackThickness*2, height-topThickness, frontAngle+10, backAngle, sideAngle, sideAngle);

            //We now make a translate to have a [0,0,0] that correspond to the corner of the top face of the ingot
            translate([-0.5*lidWidth, -0.5*lidLength, 0])
            translate([tan(90-sideAngle)*height,tan(90-frontAngle)*height,0])
            {
                innerWidth = lidWidth - 2*(tan(90-sideAngle)*height);
                windowWidth = 47;
                //We can now confortably make the little window
                // color("red")
                translate([0.5*(innerWidth-windowWidth),10,0])
                cube([windowWidth,101,height+0.5]);
            }

            //We now make the screwholes
            translate([-0.5*lidWidth, -0.5*lidLength, 0])
            {
                translate([0.5*NutDiameter+1, 0.5*frontBackThickness, 0])
                nutSlot(1,0);

                translate([lidWidth - 0.5*NutDiameter - 1, 0.5*frontBackThickness, 0])
                nutSlot(1,0);

                translate([0.5*NutDiameter+1, lidLength - 0.5*frontBackThickness, 0])
                nutSlot(1,0);

                translate([lidWidth - 0.5*NutDiameter - 1, lidLength - 0.5*frontBackThickness, 0])
                nutSlot(1,0);
            }
        }
    }

    //Lid support
    translate( GenerateInOnePiece ? [lidWidth,0,0] : [lidWidth+20,0,0])
    rotate(GenerateInOnePiece ? [0,180,0] : [0,0,0])
    difference()
    {
        ingot(lidWidth,lidLength,lidSupportThickness, 52, 52, 90,90);

        translate([0.5*NutDiameter+1, 0.5*frontBackThickness, 0])
        screwSlot(1);

        translate([lidWidth - 0.5*NutDiameter - 1, 0.5*frontBackThickness, 0])
        screwSlot(1);

        translate([0.5*NutDiameter+1, lidLength - 0.5*frontBackThickness, 0])
        screwSlot(1);

        translate([lidWidth - 0.5*NutDiameter - 1, lidLength - 0.5*frontBackThickness, 0])
        screwSlot(1);
    }
}

//Starting the bracelet
//      1111
//     2    6 
//    2      6
//    3      5
//     3    5
//      4444
//Face 1 is under the lid, 2 has the cylinder thingy, 3 the keyboard, 6 a 5 the attach thingy
braceletWidth1 = lidWidth;
braceletWidth2 = 40;
braceletWidth3 = 50;
//Normally braceletWidth4 should have the same width as braceletWidth1, according to the papertoy;
//But since I wanted to have a consistant angle between the bracelet (and because it's easier), I made it narrower to line everything up
braceletWidth4 = 53;
braceletWidth5 = 50;
braceletWidth6 = 35;

//For the 1, 2, 3, 4, and the beginning of 5
braceletLength1 =  149;
offsetFromLidToBracelet1 = 8;
//For 6
braceletLength2 = 139;
offsetFromLidToBracelet2 = 8;//lidLength-braceletLength2 -14;
braceletThickness = 4;// NutThickness + 2;
angleBetweenBraceletParts = 60;

//Face 1
//Under the lid
translate( GenerateInOnePiece ? [lidWidth,0,-lidSupportThickness] : [2*(lidWidth+20),0,0])
rotate(GenerateInOnePiece ? [0,180,0] : [0,0,0])
translate([0,offsetFromLidToBracelet1,0])
{
    ingot(braceletWidth1,braceletLength1,braceletThickness, 90, 90, 90-angleBetweenBraceletParts/2, 90-angleBetweenBraceletParts/2);
}

//Face 2
//With the cylinder
translate( GenerateInOnePiece ? 
    [lidWidth-sin(angleBetweenBraceletParts)*braceletThickness,0,-lidSupportThickness-cos(angleBetweenBraceletParts)*braceletThickness] : 
    [3*(lidWidth+20),0,0]
)
rotate(GenerateInOnePiece ? [0,angleBetweenBraceletParts,0] : [0,0,0])
translate([0,offsetFromLidToBracelet1,0])
{
    width = braceletWidth2;
    rotate([0,180,0])
    translate([-width,0,-braceletThickness])
    ingot(width,braceletLength1,braceletThickness, 90, 90, 90-angleBetweenBraceletParts/2, 90-angleBetweenBraceletParts/2);

    cylinderWidth = 106;
}

//Face 3
//With the keyboard
translate( GenerateInOnePiece ? 
    [lidWidth+cos(angleBetweenBraceletParts)*(braceletWidth2)-sin(angleBetweenBraceletParts)*braceletThickness
    ,0,-lidSupportThickness-sin(angleBetweenBraceletParts)*(braceletWidth2)+cos(angleBetweenBraceletParts)*braceletThickness] : 
    [4*(lidWidth+20),0,0]
)
rotate(GenerateInOnePiece ? [0,2*angleBetweenBraceletParts,0] : [0,0,0])
translate([0,offsetFromLidToBracelet1,0])
{
    width = braceletWidth3;
    rotate([0,180,0])
    translate([-width,0,-braceletThickness])
    ingot(width,braceletLength1,braceletThickness, 90, 90, 60, 60);
}

//Face 4
//Bottom, with the warning bit
translate( GenerateInOnePiece ? 
    [lidWidth-cos(angleBetweenBraceletParts)*(braceletWidth3-braceletWidth2),0,
    -lidSupportThickness-sin(angleBetweenBraceletParts)*(braceletWidth2+braceletWidth3)+2*cos(angleBetweenBraceletParts)*braceletThickness] : 
    [5*(lidWidth+20),0,0])
rotate(GenerateInOnePiece ? [0,180,0] : [0,0,0])
translate([0,offsetFromLidToBracelet1,0])
{
    width = braceletWidth4;
    rotate([0,180,0])
    translate([-width,0,-braceletThickness])
    ingot(width,braceletLength1,braceletThickness, 90, 90, 60, 60);
}

//Face 5
translate( GenerateInOnePiece ? 
    [-cos(angleBetweenBraceletParts)*(braceletWidth3-braceletWidth2)+sin(angleBetweenBraceletParts)*braceletThickness+(braceletWidth1-braceletWidth4)
    ,0,
    -lidSupportThickness-sin(angleBetweenBraceletParts)*(braceletWidth2+braceletWidth3)+cos(angleBetweenBraceletParts)*braceletThickness] : 
    [6*(lidWidth+20),0,0])
rotate(GenerateInOnePiece ? [0,4*angleBetweenBraceletParts,0] : [0,0,0])
translate([0,offsetFromLidToBracelet1,0])
{
    width = braceletWidth5;
    rotate([0,180,0])
    translate([-width,0,-braceletThickness])
    difference()
    {
        ingot(width,braceletLength1,braceletThickness, 90, 90, 60, 60);
        //the two notches
        translate([0,braceletLength1-10,-1])
        {
            cube([width-10,10,braceletThickness+2]);
            angle = atan((10-3)/10);
            
            translate([width-10,0,0])
            rotate([0,0,-angle])
            translate([-10,0,0])
            cube([10,100,braceletThickness+1], [10,100,10]);
        }

        translate([0,0,-1])
        {
            angle = atan((20-4)/(20-6));
            cube([width-20,20,braceletThickness+2]);
            translate([width-20,20-4,0])
            rotate([0,0,-angle])
            translate([0,-20,0])
            cube([width-20,20,braceletThickness+3]);
        }
    }

    // //Measuring thingy to help me
    // translate([0,braceletLength1-5,0])
    // color("red")
    // cube([3,4,braceletThickness+5]);
}

//Face 6
translate( GenerateInOnePiece ? 
    [-cos(angleBetweenBraceletParts)*braceletWidth6+sin(angleBetweenBraceletParts)*braceletThickness,0,
    -lidSupportThickness-cos(angleBetweenBraceletParts)*braceletThickness
    -sin(angleBetweenBraceletParts)*braceletWidth6] : 
    [7*(lidWidth+20),0,0]
)
rotate(GenerateInOnePiece ? [0,-angleBetweenBraceletParts,0] : [0,0,0])
translate([0,offsetFromLidToBracelet2,0])
{
    width = braceletWidth6;
    rotate([0,180,0])
    translate([-width,0,-braceletThickness])
    difference()
    {
        ingot(width,braceletLength2,braceletThickness, 90, 90, 90-angleBetweenBraceletParts/2, 90-angleBetweenBraceletParts/2);

        translate([width-15,0,-1])
        {
            cube([15,20,braceletThickness+2]);
            angle = atan(10/16);
            
            translate([0,16,-1])
            rotate([0,0,-90-angle])
            cube([30,10,braceletThickness+2], [10,100,10]);
        }
    }
}

module nutSlot(channelBottomOfNutsHeight, channelTopOfNutsHeight )
{
    translate([0,0,-1]) cylinder(h=1 + channelBottomOfNutsHeight + NutThickness + channelTopOfNutsHeight, d=ScrewThreadDiameter); 
    translate([0,0,channelBottomOfNutsHeight]) 
    cylinder(h=NutThickness, d=NutDiameter, $fn=6);
}

module screwSlot(height)
{
    translate([0,0,-100]) 
    cylinder(h=200, d=ScrewThreadDiameter); 

    translate([0,0,height]) 
    cylinder(h=200, d=ScrewHeadDiameter);
}

module ingot(lidWidth, lidLength, height, frontAngle, backAngle, leftAngle, rightAngle)
{
    difference()
        {
            cube([lidWidth, lidLength, height]);
            //color("red")
            rotate([frontAngle,0,0])translate([-10,0,0])cube([lidWidth+20,100,100]);
            //color("blue")
            translate([0, lidLength,0])rotate([90-backAngle,0,0])translate([-10,0,0])cube([lidWidth+20,100,100]);
            //color("blue")
            translate([0, 0,0])rotate([0,-leftAngle,0])translate([0, -10,0])cube([70,lidLength+20,100]);
            //color("red")
            translate([lidWidth, 0,0])rotate([0,-(90-rightAngle),0])translate([0, -10,0])cube([70,lidLength+20,100]);
        } 
}