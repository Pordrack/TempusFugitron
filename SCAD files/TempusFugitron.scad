use <SectorArcModule.scad>
use <BezierModule.scad>
/* [General] */
//By default smoothing (rounding edges) is turned off for preview mode, since it's very computing heavy
ActivateSmoothingOnPreview = false;
//What part to render ? A sampler is here to help you test the values for inserts and holes
PartToRender = "all"; //[all,lid,lidSupport, bracelet, cylinder,straps, strap1, strap2, sampler]

/* [Inserts and holes] */
//Diameter of the screw head + wiggle room. For M3 screws, it's 5 mm (+1 for wiggle room)
ScrewHeadDiameter = 5+1;
//Diameter of the thread of the screw + wiggle room. For M3 screws, it's 3mm(+1 for wiggle room)
ScrewThreadDiameter = 3+1;
//Diameter of the nut + wiggle room. For M3, 6mm(+1 for wiggle room)
NutDiameter = 6 + 1.0;
//How thick is the nut, + wiggle room. For M3, 2.5mm(+0.8 for wiggle room)
NutThickness = 2.5+0.8; 

//How wide are the holes for the single black cable
CableHoleDiameter = 4;
//How wide are the holes for the three wires
WiresHoleDiameter = 4;

//Length for the serflex that holes the black cable
serflexHoleWidth = 3;
//Thickness for the serflex that holes the black cable
serflexHoleThickness = 1;
//How far should the serflex hole be from the edge of the bracelet
serflexHoleOffset = 3;

/* [Lid] */
//Lid length
lidLength = 166;
//Lid width
lidWidth = 66;
//How thick is the plate undert the lid
lidSupportThickness = 4.7;

/* [Bracelet] */
//How smooth are the junctions between bracelet sections, since smoothing is very costly, it's turned off by default for preview. You'll need to render the part
BraceletSmoothingAmount = 5; //[20]
//The angle between bracelet parts
angleBetweenBraceletParts = 60;
//How thick is the bracelet
braceletThickness = 4;

//Face 1 is under the lid, 2 has the cylinder thingy, 3 the keyboard, 6 a 5 the attach thingy
braceletWidth1 = lidWidth;
//Face 2 has the cylinder
braceletWidth2 = 40;
//Face 3 has the keyboard
braceletWidth3 = 50;
//Bottom one with the warning sign, Normally braceletWidth4 should have the same width as braceletWidth1, according to the papertoy, but since I wanted to have a consistant angle between the bracelet (and because it's easier), I made it narrower to line everything up. 
braceletWidth4 = 53;
//Face 5 has the bottom of the straps
braceletWidth5 = 50;
//Face 6 has the top of the straps
braceletWidth6 = 35;

//For the face 1 through 5
braceletLength1 =  149;
//Purely here for 'full machine render'
offsetFromLidToBracelet1 = 8;
//For face 6
braceletLength2 = 139;
//Purely here for 'full machine render'
offsetFromLidToBracelet2 = 8;

/* [Straps] */
//Strap 1 width
Strap1Width = 50;
//Strap 2 width
Strap2Width = 20;
//Difference between the strap width and the width of the grooves for the straps
strapWidthLeeway = 1;  
//Length of top part of straps
StrapsLength1 = 45;
//Length of bottom part of straps
StrapsLength2 = 55;
//How thick are straps
StrapsThickness = 3.5;
//How deep are the grooves for the straps in the face
StrapGrooveDepth = 0.5;
//Angle between the top and bottom part of the straps
AngleBetweenStrapsParts = 60;
//How smooth are the junctions between bracelet sections, since smoothing is very costly, it's turned off by default for preview. You'll need to render the part
StrapsSmoothingAmount = 5;//[20]
//The offset for the first hole on the straps
StrapsFirstHoleOffset = 5;
//The diameters of the holes in the straps
StrapsHolesDiameters = 5.5;

//For full machine render. Adjust until it's okay
StrapPifometricAdjustment = 5 ;

/* [Advanced] */

$fn = $preview ? 100 : 500; 
BezierSteps = $preview ? 2 : 5;
ComputeBeziers = $preview ? ActivateSmoothingOnPreview : true;

GenerateInOnePiece =  true;
GenerateBraceletInOnePiece = true;

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
    if(PartToRender == "all" ||PartToRender == "lid")
    translate((GenerateInOnePiece) ? [0,0,0] : [-2*lidWidth,0,0])
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

               translate([8, lidLength,8])
                //And the hole for the wires
                rotate([90,0,0])
                cylinder(d=WiresHoleDiameter, h=frontBackThickness+20);
            }
        }
    }

    //Lid support
    if(PartToRender == "all" ||PartToRender == "lidSupport")
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

        translate([0.5*NutDiameter+1+sideThickness, 0.5*NutDiameter+1+frontBackThickness,lidSupportThickness])
        rotate([0,180,0])
        nutSlot(1,10,true);

        translate([lidWidth-(0.5*NutDiameter+1+sideThickness), 0.5*NutDiameter+1+frontBackThickness,lidSupportThickness])
        rotate([0,180,0])
        nutSlot(1,10,true);

        translate([0.5*NutDiameter+1+sideThickness, lidLength-(0.5*NutDiameter+1+frontBackThickness),lidSupportThickness])
        rotate([0,180,0])
        nutSlot(1,10,true);

        translate([lidWidth-(0.5*NutDiameter+1+sideThickness), lidLength-(0.5*NutDiameter+1+frontBackThickness),lidSupportThickness])
        rotate([0,180,0])
        nutSlot(1,10,true);
    }

    // translate( GenerateInOnePiece ? [lidWidth,0,0] : [lidWidth+20,0,0])
    // rotate(GenerateInOnePiece ? [0,180,0] : [0,0,0])
    
}

//Face 1
//Under the lid
if(PartToRender == "all" ||PartToRender == "bracelet")
translate( GenerateInOnePiece || GenerateBraceletInOnePiece ? [lidWidth,0,-lidSupportThickness] : [2*(lidWidth+20),0,0])
rotate(GenerateInOnePiece || GenerateBraceletInOnePiece ? [0,180,0] : [0,0,0])
translate([0,offsetFromLidToBracelet1,0])
{
    difference()
    {
        ingot(braceletWidth1,braceletLength1,braceletThickness, 90, 90, 90-angleBetweenBraceletParts/2, 90-angleBetweenBraceletParts/2);

        translate([0,-offsetFromLidToBracelet1,0])
        {
            translate([0.5*NutDiameter+1+sideThickness, 0.5*NutDiameter+1+frontBackThickness,0])
            screwSlot(1);

            translate([lidWidth-(0.5*NutDiameter+1+sideThickness), 0.5*NutDiameter+1+frontBackThickness,0])
            screwSlot(1);

            translate([0.5*NutDiameter+1+sideThickness, lidLength-(0.5*NutDiameter+1+frontBackThickness),0])
            screwSlot(1);

            translate([lidWidth-(0.5*NutDiameter+1+sideThickness), lidLength-(0.5*NutDiameter+1+frontBackThickness),0])
            screwSlot(1);
        }
    }
    
}

//Face 2
//With the cylinder
translate( GenerateInOnePiece || GenerateBraceletInOnePiece ? 
    [lidWidth-sin(angleBetweenBraceletParts)*braceletThickness,0,-lidSupportThickness-cos(angleBetweenBraceletParts)*braceletThickness] : 
    [3*(lidWidth+20),0,0]
)
rotate(GenerateInOnePiece || GenerateBraceletInOnePiece ? [0,angleBetweenBraceletParts,0] : [0,0,0])
translate([0,offsetFromLidToBracelet1,0])
{
    width = braceletWidth2;

    //The width of the cylinder at its apex
    cylinderWidth = 106;
    //The cylinder part isn't a cylinder cut in too, it's a portion of a circle taken from a certain angle on that circle, what angle is that ?
    arcAngle = 60;

    //With the width and angle, we can infer the radius of the cylinder
    radius = (0.5*cylinderWidth)/sin(arcAngle);
    //Perpendicular to the bracelet and width
    cylinderLength = radius * (1-cos(arcAngle));
    
    //Normally, the cylinder should take all width, but because the bracelet is rounded, we give it a bit of leeway
    widthLeeway =0.8;
    //At which angle is the cylinder protusing from the bracelet
    //Since we smooth the pieces, we need to change a little the width (to avoid clipping because of the curvature)
    protrusionAngle = acos(cylinderLength/(width-widthLeeway));//acos(cylinderLength/width);
    //The part of the cylinder that's protruding
    cylinderHeight = sin(protrusionAngle)*width;

    //We also prepare the translate for the screws since they'll be used at other places
    //I wanted both screw to be perfecly at the top and bottom, but since the cylinder is at an angle etc. It's very hard to find the right calculation
    //So i added these pifometric values by trial and error
    archaicValueForTheSecondScrew = 6;
    archaicValueForTheFirstScrew = 5;
    firstScrewTranslate = [(width-widthLeeway)-NutDiameter-archaicValueForTheFirstScrew+0.5*NutDiameter,braceletLength1-0.5*cylinderWidth,braceletThickness];
    secondScrewTranslate = [archaicValueForTheSecondScrew+0.5*NutDiameter,braceletLength1-0.5*cylinderWidth,braceletThickness];

    //The value for the notches
    notchAngle = 25;
    notchAngleSpan = 15;
    notchRadius = 47;
    notchRadiusSpan = 15;
    notchWallsThickness = 2;

    if(PartToRender == "all" ||PartToRender == "cylinder")
    translate(GenerateInOnePiece ? [0,0,0] : [0,0,100])
    difference()
    {
        cylinderWallThickness = 3;

        difference()
        {
            rotate([0,-protrusionAngle,0])
            translate([-(radius-cylinderLength)+sin(protrusionAngle)*braceletThickness,braceletLength1-0.5*cylinderWidth,-(cylinderHeight)+0.5*braceletThickness])  
            {
                cylinder(r=radius, h=cylinderHeight+1);
                color("red")
                linear_extrude(cylinderHeight+2) arc(notchRadius-0.5*notchRadiusSpan, 
                    [notchAngle-0.5*notchAngleSpan, notchAngle+0.5*notchAngleSpan], width = notchRadiusSpan);

                color("red")
                linear_extrude(cylinderHeight+2) arc(notchRadius-0.5*notchRadiusSpan, 
                    [-notchAngle-0.5*notchAngleSpan, -notchAngle+0.5*notchAngleSpan], width = notchRadiusSpan);
            }

            rotate([0,-protrusionAngle,0])
            translate([-(radius-cylinderLength)+sin(protrusionAngle)*braceletThickness,braceletLength1-0.5*cylinderWidth
                ,-(cylinderHeight)+0.5*braceletThickness+cylinderHeight+2-2])  
            {
                color("yellow")
                linear_extrude(3) arc(notchRadius-0.5*notchRadiusSpan+notchWallsThickness, 
                    [notchAngle-0.5*notchAngleSpan+notchWallsThickness, notchAngle+0.5*notchAngleSpan-notchWallsThickness], width = notchRadiusSpan-2*notchWallsThickness);

                color("yellow")
                linear_extrude(3) arc(notchRadius-0.5*notchRadiusSpan+notchWallsThickness, 
                    [-notchAngle-0.5*notchAngleSpan+notchWallsThickness, -notchAngle+0.5*notchAngleSpan-notchWallsThickness], width = notchRadiusSpan-2*notchWallsThickness);
            }
            
   
            rotate([0,-protrusionAngle,0])
            translate([-(radius-cylinderLength)+sin(protrusionAngle)*braceletThickness,braceletLength1-0.5*cylinderWidth,-(cylinderHeight)+0.5*braceletThickness])  
            translate([0,0,0.5*cylinderHeight+4])
            {
                rotate([40,90,0])
                color("red")
                cylinder(h=radius+1,d=CableHoleDiameter);

                translate([0,0,-2])
                rotate([30,90,0])
                color("cyan")
                cylinder(h=radius+1,d=WiresHoleDiameter);
            }
           
            

            difference()
            {
                rotate([0,-protrusionAngle,0])
                translate([-(radius-cylinderLength)+sin(protrusionAngle)*braceletThickness,braceletLength1-0.5*cylinderWidth,-(cylinderHeight)+0.5*braceletThickness])
                translate([0,0,-cylinderWallThickness-10])
                cylinder(r=radius-cylinderWallThickness, h=cylinderHeight+10);

                //These two walls will ensure that we have enough space for the nut slots we're going to add
                translate(firstScrewTranslate)
                translate([-0.5*NutDiameter,-0.5*cylinderWidth,0])
                cube([NutDiameter+2,cylinderWidth,NutThickness]);

                translate(secondScrewTranslate)
                translate([-archaicValueForTheSecondScrew-0.5*NutDiameter,-0.5*cylinderWidth,0])
                cube([NutDiameter+archaicValueForTheSecondScrew,cylinderWidth,NutThickness]);
            }

            translate(firstScrewTranslate)
            nutSlot(1,1);

            translate(secondScrewTranslate)
            nutSlot(1,1);

            //Holes for the cables
        }

        //We remove all the unwanted part of the cylinder

        rotate([0,180,0])
        translate([-width-50,-150+braceletLength1-0.5*cylinderWidth,-braceletThickness])
        cube([width+200, 300, 100]);

        //Subtil mode, to embrase the roundness of the bracelet part etc.
        // rotate([0,180,0])
        // translate([-width,0,-braceletThickness])
        // ingot(width,braceletLength1,braceletThickness, 90, 90, 90-angleBetweenBraceletParts/2, 90-angleBetweenBraceletParts/2, true);
        
        // rotate([0,180,0])
        // translate([-width-50,-150+braceletLength1-0.5*cylinderWidth,])
        // cube([width+200, 300, 100]);

        // rotate([0,180,0])
        // translate([-width,0,-braceletThickness])
        // {
        //     leftAngle = 90-angleBetweenBraceletParts/2;
        //     rightAngle = 90-angleBetweenBraceletParts/2;
        //     //translate([0, 0,0])rotate([0,-leftAngle,0])translate([0, -10,0])cube([70,braceletLength1+20,100]);
        //     //color("red")
        //     translate([width, 0,0])rotate([0,-(90-rightAngle),0])translate([0, -10,0])cube([70,braceletLength1+20,100]);
        // }

        // translate([0,braceletLength1,0])
        // cube([10,10,20]);
    }

    if(PartToRender == "all" ||PartToRender == "bracelet")
    difference()
    {
        rotate([0,180,0])
        translate([-width,0,-braceletThickness])
        ingot(width,braceletLength1,braceletThickness, 90, 90, 90-angleBetweenBraceletParts/2, 90-angleBetweenBraceletParts/2, true);

        translate(firstScrewTranslate)
        rotate([0,180,0])
        screwSlot(1);

        translate(secondScrewTranslate)
        rotate([0,180,0])
        screwSlot(1);

        //Serflex hole
        pifometricOffset = 7;
        translate([0.5*width-0.5*serflexHoleWidth+pifometricOffset,braceletLength1-serflexHoleThickness-serflexHoleOffset,-1])
        cube([serflexHoleWidth, serflexHoleThickness, braceletThickness+2]);
    }
}

//Face 3
//With the keyboard
if(PartToRender == "all" ||PartToRender == "bracelet")
translate( GenerateInOnePiece || GenerateBraceletInOnePiece ? 
    [lidWidth+cos(angleBetweenBraceletParts)*(braceletWidth2)-sin(angleBetweenBraceletParts)*braceletThickness
    ,0,-lidSupportThickness-sin(angleBetweenBraceletParts)*(braceletWidth2)+cos(angleBetweenBraceletParts)*braceletThickness] : 
    [4*(lidWidth+20),0,0]
)
rotate(GenerateInOnePiece || GenerateBraceletInOnePiece ? [0,2*angleBetweenBraceletParts,0] : [0,0,0])
translate([0,offsetFromLidToBracelet1,0])
{
    width = braceletWidth3;
    rotate([0,180,0])
    translate([-width,0,-braceletThickness])
    difference()
    {
        ingot(width,braceletLength1,braceletThickness, 90, 90, 60, 60, true, true);

        u = 19.05; //U is the standard unit for keyboard, it's the width and height of a standard key (but in actuality they're a bit smaller to avoid rubbing)
        nbrOfKeyRows = 7;
        nbrOfKeyLines = 2;
        totalKeyboardLength = 7 * u;
        totalKeyboardWidth = 2 * u;

        //We center the keyboard
        offsetX = 0.5 * (braceletLength1 - totalKeyboardLength);
        offsetY = 0.5 * (width - totalKeyboardWidth);

        translate([offsetY, offsetX, 0])
        {
            for(y = [0:nbrOfKeyLines-1])
                for(x = [0:nbrOfKeyRows-1])
                {
                    //For the two last slot of first line it's a special case
                    if(y != 1 || (x != 5 && x != 6))
                    {
                        translate([0.5*u+y*u, 0.5*u+x*u, 0])
                        screwSlot(1); 
                    }
                }

            translate([0.5*u+1*u, 0.5*u+5.5*u, 0])
            screwSlot(1); 
        }

        //Serflex hole
        pifometricOffset = 0;
        translate([0.5*width-0.5*serflexHoleWidth+pifometricOffset,braceletLength1-serflexHoleThickness-serflexHoleOffset,-1])
        cube([serflexHoleWidth, serflexHoleThickness, braceletThickness+2]);
    } 

    // color("red")
    // translate([width-20,braceletLength1-15.5,0])
    // cube([20,15.5,20]);
}

//Face 4
//Bottom, with the warning bit
if(PartToRender == "all" ||PartToRender == "bracelet")
translate( GenerateInOnePiece || GenerateBraceletInOnePiece ? 
    [lidWidth-cos(angleBetweenBraceletParts)*(braceletWidth3-braceletWidth2),0,
    -lidSupportThickness-sin(angleBetweenBraceletParts)*(braceletWidth2+braceletWidth3)+2*cos(angleBetweenBraceletParts)*braceletThickness] : 
    [5*(lidWidth+20),0,0])
rotate(GenerateInOnePiece || GenerateBraceletInOnePiece ? [0,180,0] : [0,0,0])
translate([0,offsetFromLidToBracelet1,0])
{
    width = braceletWidth4;
    rotate([0,180,0])
    translate([-width,0,-braceletThickness])
    difference()
    {
        ingot(width,braceletLength1,braceletThickness, 90, 90, 60, 60, true, true);

        //Serflex hole
        pifometricOffset = 20;
        translate([0.5*width-0.5*serflexHoleWidth+pifometricOffset,braceletLength1-serflexHoleThickness-serflexHoleOffset,-1])
        cube([serflexHoleWidth, serflexHoleThickness, braceletThickness+2]);

        //Cable hole
        pifometricOffset2 = 0;
        pifometricOffset3 = 14;
        translate([0.5*width+pifometricOffset2,braceletLength1-pifometricOffset3,-1])
        cylinder(d=CableHoleDiameter, h=braceletThickness+2);
    }
}

//Face 5
if(PartToRender == "all" ||PartToRender == "bracelet")
translate( GenerateInOnePiece || GenerateBraceletInOnePiece ? 
    [-cos(angleBetweenBraceletParts)*(braceletWidth3-braceletWidth2)+sin(angleBetweenBraceletParts)*braceletThickness+(braceletWidth1-braceletWidth4)
    ,0,
    -lidSupportThickness-sin(angleBetweenBraceletParts)*(braceletWidth2+braceletWidth3)+cos(angleBetweenBraceletParts)*braceletThickness] : 
    [6*(lidWidth+20),0,0])
rotate(GenerateInOnePiece || GenerateBraceletInOnePiece ? [0,4*angleBetweenBraceletParts,0] : [0,0,0])
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

//Face 6
if(PartToRender == "all" ||PartToRender == "bracelet")
translate( GenerateInOnePiece || GenerateBraceletInOnePiece ? 
    [-cos(angleBetweenBraceletParts)*braceletWidth6+sin(angleBetweenBraceletParts)*braceletThickness,0,
    -lidSupportThickness-cos(angleBetweenBraceletParts)*braceletThickness
    -sin(angleBetweenBraceletParts)*braceletWidth6] : 
    [7*(lidWidth+20),0,0]
)
rotate(GenerateInOnePiece || GenerateBraceletInOnePiece ? [0,-angleBetweenBraceletParts,0] : [0,0,0])
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
        translate([0, braceletLength2-Strap1Width-3+0.5*strapWidthLeeway,-1])
        cube([width,Strap1Width+strapWidthLeeway,1+StrapGrooveDepth]);

        translate([0, 30-0.5*strapWidthLeeway,-1])
        cube([width,Strap2Width+strapWidthLeeway,1+StrapGrooveDepth]);

        //Making the holes to pass cables
        spaceBetweenStraps = braceletLength2 - Strap1Width - 3 - Strap2Width - 30;
        spaceBetweenRows = 20;
        spaceBetweenLines = 8;

        totalWidth =  2.5*spaceBetweenLines + CableHoleDiameter;
        
        pifometricOffset = -1;
        translate([0.5*(width-totalWidth)+0.5*CableHoleDiameter+pifometricOffset,30+Strap2Width+0.5*strapWidthLeeway+0.5*(spaceBetweenStraps-spaceBetweenRows),-1])
        {
            for(x=[0:1])
                for(y=[0:2])
                    translate([x*0.5*spaceBetweenLines+y*spaceBetweenLines,x*spaceBetweenRows,0])
                    cylinder(d=CableHoleDiameter, h=10);
        }
    } 
}

//Straps
translate( GenerateInOnePiece ? 
    [-cos(angleBetweenBraceletParts)*StrapsLength1+sin(angleBetweenBraceletParts)*braceletThickness,0,
    -lidSupportThickness-cos(angleBetweenBraceletParts)*braceletThickness
    -sin(angleBetweenBraceletParts)*StrapsLength1] : 
    [0,(braceletLength1+20),0]
)
rotate(GenerateInOnePiece ? [0,-angleBetweenBraceletParts,0] : [0,0,0])
translate([0, offsetFromLidToBracelet2, 0])
{
    rotate([0,180,0])
    {
        if(PartToRender == "all" || PartToRender == "straps" || PartToRender == "strap1")
        color("brown")
        translate([-StrapsLength1-StrapPifometricAdjustment,0,-braceletThickness-StrapsThickness+StrapGrooveDepth])
        translate([0,braceletLength2-Strap1Width-3+strapWidthLeeway,0])
        {
            difference()
            {
                ingot(StrapsLength1,Strap1Width,StrapsThickness, 90, 90, AngleBetweenStrapsParts/2, 90-AngleBetweenStrapsParts/2, true, true, BraceletSmoothingAmount, StrapsSmoothingAmount);
                translate([0.5*StrapsLength1+StrapsFirstHoleOffset,0.5*Strap1Width,-1])
                cylinder(h=2*StrapsThickness, d=StrapsHolesDiameters, $fn=6);
                
                translate([0,0,StrapsThickness])
                cube([StrapsLength1-StrapsSmoothingAmount, Strap1Width, StrapsThickness]);
            }
            
            
            

            translate([StrapsLength1, 0 , 0])
            rotate([0,-AngleBetweenStrapsParts,0])
            {
                difference()
                {
                    union()
                    {
                        ingot(StrapsLength2-0.5*Strap1Width,Strap1Width,StrapsThickness, 90, 90, 90-AngleBetweenStrapsParts/2, 90, true, false,StrapsSmoothingAmount);

                        translate([StrapsLength2-0.5*Strap1Width,0.5*Strap1Width,0])
                        rotate([0,0,180])
                        linear_extrude(StrapsThickness) sector(Strap1Width/2, [90,270]);
                    }

                    for(i = [1:3])
                    {
                        translate([(i/4)*StrapsLength2,0.5*Strap1Width,-1])
                        cylinder(h=2*StrapsThickness, d=StrapsHolesDiameters, $fn=6);
                    }
                }
            }  
        } 


        if(PartToRender == "all" || PartToRender == "straps" || PartToRender == "strap2")
        translate([-StrapsLength1-StrapPifometricAdjustment,0,-braceletThickness-StrapsThickness+StrapGrooveDepth])
        translate([0, 30,0])
        color("brown")
        {
            difference()
            {
                ingot(StrapsLength1,Strap2Width,StrapsThickness, 90, 90, AngleBetweenStrapsParts/2, 90-angleBetweenBraceletParts/2, true, true, BraceletSmoothingAmount, StrapsSmoothingAmount);
                translate([0.5*StrapsLength1+StrapsFirstHoleOffset,0.5*Strap2Width,-1])
                cylinder(h=2*StrapsThickness, d=StrapsHolesDiameters, $fn=6);

                translate([0,0,StrapsThickness])
                cube([StrapsLength1-StrapsSmoothingAmount, Strap1Width, StrapsThickness]);
            }
            
            translate([StrapsLength1, 0 , 0])
            rotate([0,-AngleBetweenStrapsParts,0])
            {
                difference()
                {
                    union()
                    {
                        ingot(StrapsLength2-0.5*Strap2Width,Strap2Width,StrapsThickness, 90, 90, 90-AngleBetweenStrapsParts/2, 90, true, false,StrapsSmoothingAmount);

                        translate([StrapsLength2-0.5*Strap2Width,0.5*Strap2Width,0])
                        rotate([0,0,180])
                        linear_extrude(StrapsThickness) sector(Strap2Width/2, [90,270]);
                    }

                    for(i = [1:3])
                    {
                        translate([(i/4)*StrapsLength2,0.5*Strap2Width,-1])
                        cylinder(h=2*StrapsThickness, d=StrapsHolesDiameters, $fn=6);
                    }
                }
            }  
        }    
    }
}

if(PartToRender == "sampler")
difference()
{
    thickness = 1 + NutThickness;
    width = 2 + max(NutDiameter, ScrewHeadDiameter, CableHoleDiameter, WiresHoleDiameter);
    length = 1+NutDiameter+1+1+2*ScrewHeadDiameter+1+serflexHoleWidth+1+CableHoleDiameter+1+WiresHoleDiameter+1;
    translate([0, -0.5*width, 0])
    cube([length,width,thickness]);
    translate([1+NutDiameter/2,0,0])
    nutSlot(1,0, true);

    translate([1+NutDiameter+1+0.5*ScrewHeadDiameter,0,0])
    screwSlot(2);

    translate([1+NutDiameter+1+1+1.5*ScrewHeadDiameter,0,0])
    screwSlot(1);

    translate([1+NutDiameter+1+1+2*ScrewHeadDiameter+1,0.5*width-serflexHoleThickness-serflexHoleOffset,-1])
    cube([serflexHoleWidth, serflexHoleThickness, thickness+2]);

    translate([1+NutDiameter+1+1+2*ScrewHeadDiameter+1+serflexHoleWidth+1+0.5*CableHoleDiameter,0,-1])
    cylinder(d=CableHoleDiameter, h = thickness+2);

    translate([1+NutDiameter+1+1+2*ScrewHeadDiameter+1+serflexHoleWidth+1+CableHoleDiameter+1+0.5*WiresHoleDiameter,0,-1])
    cylinder(d=WiresHoleDiameter, h= thickness+2);
}

module nutSlot(channelBottomOfNutsHeight, channelTopOfNutsHeight, openTop=false)
{
    translate([0,0,-1]) cylinder(h=1 + channelBottomOfNutsHeight + NutThickness + channelTopOfNutsHeight, d=ScrewThreadDiameter); 
    translate([0,0,channelBottomOfNutsHeight]) 
    cylinder(h=openTop ? (NutThickness+1+channelTopOfNutsHeight+channelBottomOfNutsHeight) : NutThickness , d=NutDiameter, $fn=6);
}

module screwSlot(height)
{
    translate([0,0,-100]) 
    cylinder(h=200, d=ScrewThreadDiameter); 

    translate([0,0,height]) 
    cylinder(h=200, d=ScrewHeadDiameter);
}

module ingot(width, length, height, frontAngle, backAngle, leftAngle, rightAngle, smoothLeft = false, smoothRight = false
    , smoothAmountLeft = BraceletSmoothingAmount, smoothAmountRight = BraceletSmoothingAmount)
{
    //Rotate x and y around 0,0
    function rotate(point,angle) =
        let (x1 = point[0] )
        let (y1 = point[1] )
        let (x2 = cos(angle) * x1 - sin(angle) * y1 )
        let (y2 = sin(angle) * x1 + cos(angle) * y1 )
            [x2, y2];

    function pointOnThisIngot(smoothAmount) = 
        [0,smoothAmount];
    
    function pointOnNextIngot(smoothAmount, angleToUse) =
        rotate(pointOnThisIngot(smoothAmount), 2*angleToUse);

    focalPoint = [0,0];

    difference()
        {
            union()
            {
                cube([width, length, height]);

                if(ComputeBeziers && smoothLeft)
                    rotate([90,90,0])
                    translate([-height,tan(90-leftAngle)*height,-length-1]) 
                    BezQuadCurve( [pointOnNextIngot(smoothAmountLeft, leftAngle),focalPoint,focalPoint
                        ,pointOnThisIngot(smoothAmountLeft)], focalPoint, 10, length+1);

                if(ComputeBeziers && smoothRight)
                    rotate([-90,90,0])
                    translate([-height,-width+tan(90-rightAngle)*height,0])
                    BezQuadCurve( [pointOnNextIngot(smoothAmountRight, rightAngle),focalPoint,focalPoint
                        ,pointOnThisIngot(smoothAmountRight)], focalPoint, 10, length+1);
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
                BezQuadCurve( [pointOnNextIngot(smoothAmountLeft, leftAngle),focalPoint,focalPoint,pointOnThisIngot(smoothAmountLeft)], focalPoint, 10, length+1);

            if(ComputeBeziers && smoothRight)
                rotate([-90,90,0])
                translate([0,-width,0]) 
                BezQuadCurve( [pointOnNextIngot(smoothAmountRight, rightAngle),focalPoint,focalPoint,pointOnThisIngot(smoothAmountRight)], focalPoint, 10, length+1);
        }  
}