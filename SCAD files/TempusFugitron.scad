use <SectorArcModule.scad>
use <BezierModule.scad>

//You should add somme wiggle room to the measurement for the screws. Personally A little over 1mm was necessery
ScrewHeadDiameter = 5+1;
ScrewHeadThickness = 3; 
ScrewThreadDiameter = 3+1;
NutDiameter = 6 + 0.5;
NutThickness = 2.5+0.8; 

BraceletSmoothingAmount = 5; //I advise to not go above 20

$fn = $preview ? 100 : 500; 
BezierSteps = $preview ? 2 : 100;
ComputeBeziers = $preview ? true : true;

GenerateInOnePiece = true;

lidLength = 166;
lidWidth = 66;
lidSupportThickness = 4.7;

//Top part
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
    ingot(width,braceletLength1,braceletThickness, 90, 90, 90-angleBetweenBraceletParts/2, 90-angleBetweenBraceletParts/2, true);

    //The width of the cylinder at its apex
    cylinderWidth = 106;
    //The cylinder part isn't a cylinder cut in too, it's a portion of a circle taken from a certain angle on that circle, what angle is that ?
    arcAngle = 60;

    //With the width and angle, we can infer the radius of the cylinder
    radius = (0.5*cylinderWidth)/sin(arcAngle);
    //Perpendicular to the bracelet and width
    cylinderLength = radius * (1-cos(arcAngle));

    //At which angle is the cylinder protusing from the bracelet
    protrusionAngle = acos(cylinderLength/width);
    //The part of the cylinder that's protruding
    cylinderHeight = sin(protrusionAngle)*width;
    
    difference()
    {
        cylinderWallThickness = 3;
        rotate([0,-protrusionAngle,0])
        translate([-(radius-cylinderLength)+sin(protrusionAngle)*braceletThickness,braceletLength1-0.5*cylinderWidth,-(cylinderHeight)+0.5*braceletThickness])
        difference()
        {
            cylinder(r=radius, h=cylinderHeight+1);
            translate([0,0,-cylinderWallThickness-10])
            cylinder(r=radius-cylinderWallThickness, h=cylinderHeight+10);
        }
        
        rotate([0,180,0])
        translate([-width-50,-150+braceletLength1-0.5*cylinderWidth,-braceletThickness])
        cube([width+200, 300, 100]);
    }
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
    ingot(width,braceletLength1,braceletThickness, 90, 90, 60, 60, true, true);
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
    ingot(width,braceletLength1,braceletThickness, 90, 90, 60, 60, true, true);
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
        ingot(width,braceletLength1,braceletThickness, 90, 90, 60, 60, true, true);
        //the two notches
        translate([0,braceletLength1-10,-5])
        {
            cube([width-10,10,braceletThickness+10]);
            angle = atan((10-3)/10);
            
            translate([width-10,0,0])
            rotate([0,0,-angle])
            translate([-10,0,0])
            cube([10,100,braceletThickness+10]);
        }

        translate([0,0,-5])
        {
            angle = atan((20-4)/(20-6));
            cube([width-20,20,braceletThickness+10]);
            translate([width-20,20-4,0])
            rotate([0,0,-angle])
            translate([0,-20,0])
            cube([width-20,20,braceletThickness+10]);
        }
    }

    // //Measuring thingy to help me
    // translate([0,braceletLength1-5,0])
    // color("red")
    // cube([3,4,braceletThickness+5]);
}

Strap1Width = 50;
Strap2Width = 20;

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
        ingot(width,braceletLength2,braceletThickness, 90, 90, 90-angleBetweenBraceletParts/2, 90-angleBetweenBraceletParts/2, false, true);

        translate([width-15,0,-5])
        {
            cube([15,20,braceletThickness+10]);
            angle = atan(10/16);
            
            translate([0,16,5])
            rotate([0,0,-90-angle])
            cube([30,10,braceletThickness+2], [10,100,10]);
        }

        //Making the grooves for the braces
        //Leeway between the grooves and the real strap
        strapWidthLeeway = 1;
        strapGrooveDepth = 0.5;

        translate([0, braceletLength2-Strap1Width-3+0.5*strapWidthLeeway,-1])
        cube([width,Strap1Width+strapWidthLeeway,1+strapGrooveDepth]);

        translate([0, 30-0.5*strapWidthLeeway,-1])
        cube([width,Strap2Width+strapWidthLeeway,1+strapGrooveDepth]);
    } 

//     strapWidthLeeway = 1;
//         strapGrooveDepth = 1;
//  translate([-width,0,-braceletThickness])
//         translate([width, braceletLength2-Strap1Width-3+0.5*strapWidthLeeway,2*braceletThickness-strapGrooveDepth])
//         cube([width,Strap1Width+strapWidthLeeway,10]);
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

module ingot(width, length, height, frontAngle, backAngle, leftAngle, rightAngle, smoothLeft = false, smoothRight = false)
{
    //Rotate x and y around 0,0
    function rotate(point,angle) =
        let (x1 = point[0] )
        let (y1 = point[1] )
        let (x2 = cos(angle) * x1 - sin(angle) * y1 )
        let (y2 = sin(angle) * x1 + cos(angle) * y1 )
            [x2, y2];

    //Smooth side only makes sense for ingots with the same left and right angle, since it's there to smooth a potential link to another ingots with the attributs
    focalPoint = [0,0];
    pointOnThisIngot = [0, 5];
    pointOnNextIngot = rotate(pointOnThisIngot, 2*leftAngle);

    difference()
        {
            union()
            {
                cube([width, length, height]);

                if(ComputeBeziers && smoothLeft)
                    rotate([90,90,0])
                    translate([-height,tan(90-leftAngle)*height,-length-1]) 
                    BezQuadCurve( [pointOnNextIngot,focalPoint,focalPoint,pointOnThisIngot], focalPoint, 10, length+1);

                if(ComputeBeziers && smoothRight)
                    rotate([-90,90,0])
                    translate([-height,-width+tan(90-leftAngle)*height,0])
                    BezQuadCurve( [pointOnNextIngot,focalPoint,focalPoint,pointOnThisIngot], focalPoint, 10, length+1);
            }
            
            //color("red")
            rotate([frontAngle,0,0])translate([-10,0,0])cube([width+20,100,100]);
            //color("blue")
            translate([0, length,0])rotate([90-backAngle,0,0])translate([-10,0,0])cube([width+20,100,100]);
            //color("blue")
            translate([0, 0,0])rotate([0,-leftAngle,0])translate([0, -10,0])cube([70,length+20,100]);
            //color("red")
            translate([width, 0,0])rotate([0,-(90-rightAngle),0])translate([0, -10,0])cube([70,length+20,100]);

            
    
            if(ComputeBeziers && smoothLeft)
                rotate([90,90,0])
                translate([0,0,-length-1]) 
                BezQuadCurve( [pointOnNextIngot,focalPoint,focalPoint,pointOnThisIngot], focalPoint, 10, length+1);

            if(ComputeBeziers && smoothRight)
                rotate([-90,90,0])
                translate([0,-width,0]) 
                BezQuadCurve( [pointOnNextIngot,focalPoint,focalPoint,pointOnThisIngot], focalPoint, 10, length+1);
        }  
}