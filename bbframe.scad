// BrakerBot2025 toandrey(at)yahoo.com
// Brakes actuated by servo motors (not shown) transfer torque from disks to limbs
// Print everything with 0.3mm layers without support
// Uses 1/2" pvc pipe, 608 bearings, 95mm disks from Hard Drives, HS300 servos
// Every joint uses four or five bearings (not shown), 2 disks and 3 gears
//
// Outer diameter of the 608 bearing is 22mm.  ID 8mm
// Outer diameter of the 1/2" pvc pipe is 21.5mm
// TODO: redesign second side of the frame to match the other side
// make it longer.  make it symmetrical

use <bcstr.scad> // b(),c(),s(),t(),r()
include <BOSL2/std.scad>
include <BOSL2/gears.scad>
$fn=128; // make cylinders a bit rounder
skipdraw = false; // allows quickly temporary disable drawing for debugging
shaft_round = 8; // 608 bearings fit an 8mm round shaft
// if you grind an end of a round shaft into a square, it will be this size
shaft_square = sqrt(shaft_round*shaft_round/2);
echo("Shaft end square size", shaft_square);

module flatten(top=8){ // remove everything below top
    intersection(){
        children();
        t(0,0,100-top) b(200,200,200); // introduces a visual glitch
    }
}

module frame(){
    difference(){
        union(){
            difference(){
                t(0,28.5,0) b(68,57,16); // c-frame
                b(52,98,17);
            }
            flatten() t(30,0,0) r(0,90,0) c(24,25);  // bearing block
            flatten() t(-34,0,0) r(0,90,0) c(32,25); // bearing block
            t(30,30,0)  r(0,0,20)  b(8,45,8);        // ribs to make frame more rigid
            t(-30,30,0) r(0,0,-20) b(8,45,8);
        }
        t(34,0,0)    r(0,90,0) c(29,22);  // pipe and bearing hole
        t(-34,0,0)   r(0,90,0) c(29,22);  // bearing hole
        t(5,0,0)     r(0,90,0) c(100,11); // shaft hole
        t(0,50,0)    r(90,0,0) c(20,3);   // bracket screw hole center
        t(29,45,0)   r(90,0,0) c(30,3);   // bracket screw hole side
        t(-29,45,0)  r(90,0,0) c(30,3);   // bracket screw hole side
        t(38,0,13.3) c(4,3);              // vertical screw hole in bearing block
        r(60,0,0)    t(38,0,-10) c(20,3); // screw hole in bearing block
        r(-60,0,0)   t(38,0,-10) c(20,3); // screw hole in bearing block
        t(30,52,0)   r(0,90,0) c(12,3);   // screw holes for bolting
        t(-30,52,0)  r(0,90,0) c(12,3);   // two frames together
    }
}

module hingeBridge(){
    difference(){
        union(){
            t(0,-0.5,0) b(68,9,16); // beam
            flatten()   t(0,14.5,0) r(90,0,0) c(39,25); // bearing block
            t(0,15,-4)  b(25,38,8); // makes bearing block bottom square
            t(0,0,10)   b(68,4,5);  // top bar for rigidity

            t(30,4,0)   b(8,16,16); // wing 1
            t(30,12,0)  r(45,0,0) b(8,11.3,11.3);

            t(-30,4,0)  b(8,16,16); // wing 2
            t(-30,12,0) r(45,0,0) b(8,11.3,11.3);
        }
        t(0,11.5,0)   r(90,0,0) c(42,22); // pipe and bearing hole
        r(90,0,0)     c(100,11);          // shaft hole
        t(0,18,13.3)  c(4,3);             // screw hole in bearing block. 13.3 for "print support"
        t(21.95,0,0)  b(8.1,8.1,8.1);     // cube hole for hinges
        t(-21.95,0,0) b(8.1,8.1,8.1);     // cube hole for hinges
        r(0,90,0)     c(70,3);            // 2 screw holes
        t(25,13,0)    r(0,90,0) c(20,3);  // screw hole in wing
        t(-25,13,0)   r(0,90,0) c(20,3);  // screw hole in wing
    }
}

module hingeSide(){
    difference(){
        union(){
            r(0,90,0) c(8,34);    // pipe
            t(0,30,0) b(8,38,16); // side
            t(0,52,0) b(8,10,8);  // bridge connector
        }
        r(0,90,0) c(10,26);          // hinge hole
        t(0,53,0) r(0,90,0) c(10,3); // screw hole
        t(0,40,0) r(0,90,0) c(10,3); // screw hole
    }
}
// skipdraw=true; // display just this:
// t(21,0,0) hingeBridge();
// t(0,53,0) r(0,0,180) hingeSide();

module hingeAssembly(){ // for visualization only
    color("yellow") t(22,0,0)  r(180,180,0) hingeSide();
    color("yellow") t(-22,0,0) r(180,0,0)   hingeSide();
    color("green")  t(0,-53,0)              hingeBridge();
}

module legCap(){ // attaches pipe to lower joint
    flatten(21.5/2) // shave top off this cap level with pipe
    difference(){
        union(){
            b(32,8,16);
            b(66,8,8);
            t(0,6,0) r(90,0,0) c(20,25);
        }
        t(0,9,0)   r(90,0,0)   c(20,22); // pvc pipe hole
        t(0,5,0)               c(30,3);  // pipe screw hole
        r(0,120,0) t(0,10,10)  c(20,3);  // pipe screw hole
        r(0,60,0)  t(0,10,-10) c(20,3);  // pipe screw hole
                   r(90,0,0)   c(20,3);  // center screw hole
        t(29,0,0)  r(90,0,0) c(20,3);    // side screw hole
        t(-29,0,0) r(90,0,0) c(20,3);    // side screw hole
    }
}

module cap(){ // side cap for the lower joint
    difference(){
        c(16, 28);                      // cap body
        t(0,0,1.5)   c(16,22.2);        // bearing hole (.2 tolerance)
        t(0,0,8.5)   c(16,25);          // slides over bearing block
        t(0,-12,5)   b(8.2,6,7);        // side cutout
        t(-10,0,4.5) r(0,90,0)   c(30,3); // top screw hole
        r(90,0,30)   t(0,4.5,5)  c(20,3); // screw hole
        r(90,0,-30)  t(0,4.5,-5) c(20,3); // screw hole
        t(5,0,0)     c(20,3);           // bottom holes to help
        t(-5,0,0)    c(20,3);           // take out bearing
    }
}

module stiffBar(){
    difference(){
        b(68,8,8);
        t(29,0,0)  r(90,0,0) c(20,3); // side screw hole
        t(-29,0,0) r(90,0,0) c(20,3); // side screw hole
                   r(90,0,0) c(20,3); // center screw hole
    }
}

// differential gear with a square shaft hole
module dgear(){
    shaft_hole = shaft_square + 0.3; // + tolerance
    gteeth  = 12;
    difference(){
        union(){
            bevel_gear(teeth=gteeth, mate_teeth=gteeth, mod=2, cutter_radius=0, spiral=0, shaft_diam=1);
            t(0,0,-2.2) c(0.9,27.3); // disk stop
        }
        b(shaft_hole,shaft_hole,20);
    }
}

module diskMount(){
    shaft_hole = shaft_square + 0.3; // + tolerance
    difference(){
        union(){
            intersection(){
                t(0,7.5,0.75) b(2,15,1.5); // key
                c(5,27.3);
            }
            t(0,0,0.75)  c(1.5, 25);  // base for mounting a brake disk
            t(0,0,-0.45) c(0.9,27.3); // disk stop
        }
        b(shaft_hole,shaft_hole,20);
    }
}

// skipdraw=true;
// diskMount();

module gearAssembly(){ // for visualization only
    dgear();
    t(0,0,-4.1) diskMount();
}

module axle1(len){
    t(0,0,17/2) b(shaft_square,shaft_square,17); // 1 gear mount
    t(0,0,-16) c(32,shaft_round);                // bearings mount here
}

module axle2(len){
    b(shaft_square,shaft_square,len); // 2 gear mounts
    c(len-14,shaft_round);            // bearings mount here
}

// spacer between two bearings around axle1() to lock bearings in place
module sleve(len=14.1){
    pipe(len, 8.4+1.8, 8.4); // len, od, id // 0.9mm wall
}


if(!skipdraw){ // set skipdraw=true for quick debugging of individual parts
if($preview){
    color("red")  t(0,-97,0)    r(90,0,0) axle2(174);
    color("red")  t(-45,-195,0) r(0,90,0) axle1(); // 2 per joint
    color("teal") t(-60,-195,0) r(0,90,0) sleve(); // spacer between bearings

    t(240,0,0) r(-90,90,0) frame(); // the other leg
    t(120,0,0) r(90,90,0) frame();
    t(120,0,0) r(90,90,0) hingeAssembly();
    frame();
    hingeAssembly();
    t(0,-195,0) r(0,0,180) frame();
    t(0,-195,0) r(0,0,180) hingeAssembly();

//  t(33.5,0,0)
    t(-80,-195,0) r(0,90,0)    cap();
    t(0,-260,0)   r(180,180,0) legCap();
    t(0,70,0)     stiffBar();

    t(12,-195,0)  r(0,-90,0)     gearAssembly();
    t(0,-183,0)   r(90,360/24,0) dgear(); // N teeth. rotate 1/2 tooth
    t(-12,-195,0) r(0,90,0)      gearAssembly();

%   t(0,-360,0)   r(90,0,0) c(200,21.5); // pvc pipe
%   t(0,-98,0)    r(90,0,0) c(140,21.5); // pvc pipe
%   t(60,0,0)     r(0,90,0) c(66,21.5);  // pvc pipe
%   t(15,-195,0)  r(0,90,0) c(1.5,95);   // brake disk
%   t(-15,-195,0) r(0,90,0) c(1.5,95);   // brake disk
} else { // rendering for 3D printing
    // axle2(len);  // len depends on PVC pipe length
    t(-50,45,0)  r(90,45,0) axle1(); // fixed length for each joint
    t(-70,45,0)  r(90,45,0) axle1(); // need 2 per joint
    t(-70,90,0)  sleve();            // need 2 per joint
    t(-50,90,0)  sleve();
    sleve(7.5); // shaft spacer between gear and bearing
    t(110,80,0)  cap();
    t(110,20,0)  r(90,0,-90) legCap();

    frame();
    t(-70,-20,0) r(90,0,90)  stiffBar();
    t(70,40,0)   r(180,90,0) hingeSide();
    t(110,-40,0) r(0,90,90)  hingeSide(); // need two per joint
    t(10,-50,0)  hingeBridge();

    t(70,80,0)   dgear();
    t(30,80,0)   dgear();
    t(-10,80,0)  dgear();
    t(0,25,0)    diskMount();
    t(-45,-35,0) diskMount();
} // if($preview)
} // skipdraw
