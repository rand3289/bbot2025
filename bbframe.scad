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
    d = 33;
    difference(){
        union(){
            difference(){
                t(0,28.5,0) b(66,57,16); // c-frame
                b(50,98,17);
            }
            flatten() t(29,0,0) r(0,90,0) c(24,25); // bearing block
            flatten() t(-d,0,0) r(0,90,0) c(32,25); // bearing block
            t(29,30,0)  r(0,0,20)  b(8,45,8);       // ribs to make frame more rigid
            t(-29,30,0) r(0,0,-20) b(8,45,8);
        }
        t(d,0,0)  r(0,90,0) c(29,22);  // pipe and bearing hole
        t(-d,0,0) r(0,90,0) c(29,22);  // bearing hole
        t(5,0,0)  r(0,90,0) c(100,11); // shaft hole
        t(8,0,0)  r(90,0,0) c(200,3);  // bracket screw hole
        t(-8,0,0) r(90,0,0) c(200,3);  // bracket screw hole
        t(37,0,13.3) c(4,3);           // vertical screw hole in bearing block
        t(37,0,0) r(90,0,0) c(100,3);  // horisontal screw hole in bearing block
    }
}

module hingeBridge(){
    difference(){
        union(){
            b(54,8,16); // beam
            flatten()  t(0,15,0) r(90,0,0) c(38,25); // bearing block
            t(0,15,-4) b(25,38,8); // make bearing block bottom square
        }
        t(0,11.5,0) r(90,0,0)  c(42,22); // pipe and bearing hole
        r(90,0,0)   c(100,11);           // shaft hole
        t(21,0,0)   b(8.2,12,10.2);      // hole for hinges
        t(-21,0,0)  b(8,12,10);          // hole for hinges
        r(0,90,0)   c(60,3);             // 2 screw holes
        t(0,0,13.3) c(4,3);              // screw hole in bearing block. 13.3 for "print support"
    }
}

module hingeSide(){
    difference(){
        union(){
            r(0,90,0) c(8,28.8);  // pipe
            t(0,30,0) b(8,38,16); // side
            t(0,52,0) b(8,10,10); // bridge connector
        }
        r(0,90,0) c(10,26);          // hinge hole
        t(0,53,0) r(0,90,0) c(10,3); // screw hole
    }
}

module hingeAssembly(){ // for visualization only
    color("yellow") t(21,0,0)  r(180,180,0) hingeSide();
    color("yellow") t(-21,0,0) r(180,0,0)   hingeSide();
    color("green")  t(0,-53,0)              hingeBridge();
}

module legCap(){ // attaches pipe to lower joint
    flatten(21.5/2) // shave top off this cap level with pipe
    difference(){
        union(){
            b(26,8,16);
            t(0,6,0) r(90,0,0) c(20,25);
        }
        t(0,9,0)  r(90,0,0) c(20,22); // pipe mounting hole
        t(0,10,0) r(0,90,0) c(30,3);  // pipe screw hole
        t(0,10,0)           c(30,3);  // pipe screw hole
        t(8,0,0)  r(90,0,0) c(20,3);  // leg attachment screw hole
        t(-8,0,0) r(90,0,0) c(20,3);  // leg attachment screw hole
    }
}

module cap(){ // side cap for the lower joint
    difference(){
        c(16, 28);                    // cap body
        t(0,0,1.5) c(16,22.2);        // bearing hole (.2 tolerance)
        t(0,0,8.5) c(16,25);          // slides over bearing block
        t(-10,0,4) r(0,90,0) c(30,3); // 1 screw hole
        t(0,0,4)   r(90,0,0) c(30,3); // 2 screw holes
        t(5,0,0)   c(20,3);           // bottom hole to help take out the bearing
        t(-5,0,0)  c(20,3);           // bottom hole
    }
}

// differential gear with a square shaft hole
module dgear(){
    disk_id = 25.2; // .2 for tolerance
    gteeth  = 14;
    shaft_hole = shaft_square + 0.3; // + tolerance

    difference(){
        union(){
            t(0,0,4.5)  bevel_gear(teeth=gteeth, mate_teeth=gteeth, mod=1.5, cutter_radius=0, spiral=0, shaft_diam=1);
            t(0,0,2.25) c(2, 18);        // base disk to gear connector
            t(0,0,0.4)  c(1.8, disk_id); // base for mounting a brake disk
            t(0,0,-0.9) c(0.9,27);       // brake disk endstop
        }
        b(shaft_hole,shaft_hole,20);
    }
}

module dgear2(){
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
            t(0,0,0.75)  c(1.5, 25);  // base for mounting a brake disk
            t(0,0,-0.45) c(0.9,27.3); // disk stop
        }
        b(shaft_hole,shaft_hole,20);
    }
}

module gearAssembly(){ // for visualization only
    dgear2();
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
    pipe(len, 8.2+1.8, 8.2); // len, od, id // 0.9mm wall
}


if($preview){
    color("red")  t(0,-97,0)    r(90,0,0) axle2(174);
    color("red")  t(-50,-195,0) r(0,90,0) axle1(); // 2 per joint
    color("teal") t(-64,-195,0) r(0,90,0) sleve(); // spacer between bearings

    t(120,0,0) r(90,90,0) frame();
    t(120,0,0) r(90,90,0) hingeAssembly();
    frame();
    hingeAssembly();
    t(0,-195,0) r(0,0,180) frame();
    t(0,-195,0) r(0,0,180) hingeAssembly();

    t(-75,-195,0) r(0,90,0)    cap();
    t(0,-260,0)   r(180,180,0) legCap();

    t(12,-196,0)  r(0,-90,0)     gearAssembly();
    t(0,-184,0)   r(90,360/24,0) gearAssembly(); // N teeth. rotate 1/2 tooth
    t(-12,-196,0) r(0,90,0)      gearAssembly();

%   t(0,-360,0)   r(90,0,0) c(200,21.5); // pvc pipe
%   t(0,-98,0)    r(90,0,0) c(140,21.5); // pvc pipe
%   t(60,0,0)     r(0,90,0) c(66,21.5);  // pvc pipe
%   t(15,-195,0)  r(0,90,0) c(1.5,95);   // brake disk
%   t(-15,-195,0) r(0,90,0) c(1.5,95);   // brake disk
} else { // rendering for 3D printing
    t(-50,50,0)  r(90,45,0) axle1(); // fixed length for each joint
    t(-70,50,0)  r(90,45,0) axle1(); // need 2 per joint
    t(-70,-20,0) sleve();            // need 2 per joint
    t(-70,0,0)   sleve();
    // axle2(len) // len depends on PVC pipe length
    t(120,40,0)  cap();
    t(120,0,0)   r(90,0,0)   legCap();
    t(70,40,0)   r(180,90,0) hingeSide();
    t(100,-40,0) r(0,90,90)  hingeSide(); // need two per joint
    t(0,-50,0)   hingeBridge();
    frame();

    t(80,80,0)   dgear2();
    t(40,80,0)   dgear2();
    t(0,80,0)    dgear2();
    t(80,110,0)  diskMount();
    t(40,110,0)  diskMount();
    t(0,110,0)   diskMount();

    // shaft spacers for testing
              sleve(1.2);
    t(10,0,0) sleve(2.1);
    t(20,0,0) sleve(3.0);
    t(30,0,0) sleve(3.9);
}
