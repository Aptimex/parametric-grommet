/* [Tunnel] */
innerDia = 15.01;
// The diameter of your hole
outerDia = 19.01;
// Depth of your hole. Flanges are extra
wallDepth = 12.7;

/* [Top Flange] */
// Make equal to outerDia to remove the flange
topFlangeDia = 21;
// Thickness of the outer flange that grips the wall
topFlangeH = 3;
// Thickness of the flap that keeps stuff out of the grommet
topFlapDep = 1.2;
// Set equal to innerDia to remove flap
topFlapHoleDia = 0;

/* [Bottom Flange] */
// Set to -1 to use the same value as topFlangeDia
bottomFlangeDiameter = -1;
// Set to -1 to use the same value as topFlangeH
bottomFlangeHeight = -1;
// Set to -1 to use the same value as topFlapDep
bottomFlapDepth = -1;
// Set to -1 to use the same value as topFlapHoleDia
bottomFlapHoleDiameter = -1;

/* [Print] */
// Print in one piece, or split along length or width for support-less printing
cut = 1; // [0:None, 1:hotdog, 2:hamburger]


module null() {
    // just make customizer stop parsing variables
}
$fn=128 + 0;
e = .01 + 0;

bottomFlangeDia = (bottomFlangeDiameter < 0) ? topFlangeDia : bottomFlangeDiameter;
bottomFlangeH = (bottomFlangeHeight < 0) ? topFlangeH : bottomFlangeHeight;
bottomFlapHoleDia = (bottomFlapHoleDiameter < 0) ? topFlapHoleDia : bottomFlapHoleDiameter;
bottomFlapDep = (bottomFlapDepth < 0) ? topFlapDep : bottomFlapDepth;

module topFlange() {
    translate([0, 0, topFlangeH/2]) {
        difference() {
            cylinder(d=topFlangeDia, h=topFlangeH, center=true);
            cylinder(d=innerDia, h=topFlangeH+2*e, center=true);
        }
        
        //flap
        translate([0, 0, (topFlangeH-topFlapDep)/2]) difference() {
            cylinder(d=innerDia+e, h=topFlapDep, center=true);
            cylinder(d=topFlapHoleDia, topFlapDep*2, center=true);
        }
    }
        
}

module bottomFlange() {
    translate([0, 0, -wallDepth-bottomFlangeH/2]) {
        difference() {
            cylinder(d=bottomFlangeDia, h=bottomFlangeH, center=true);
            cylinder(d=innerDia, h=bottomFlangeH+2*e, center=true);
        }
        
        //flap
        translate([0, 0, -(topFlangeH-topFlapDep)/2]) difference() {
            cylinder(d=innerDia+e, h=topFlapDep, center=true);
            cylinder(d=topFlapHoleDia, topFlapDep*2, center=true);
        }
    }
}

module tunnel() {
    height = wallDepth+topFlangeH+bottomFlangeH;
    
    translate([0, 0, -wallDepth/2]) difference() {
        cylinder(d=outerDia+e, h=wallDepth, center=true);
        cylinder(d=innerDia, h=height+2*e, center=true);
    }
}

module grommet() {
    topFlange();
    tunnel();
    bottomFlange();
}

module halfGrommet1() {
    w=topFlangeDia+bottomFlangeDia;
    height = wallDepth+topFlangeH+bottomFlangeH;
    
    difference() {
        grommet();
        translate([0, -w/2, -height*2]) cube(size=[w, w, height*4]);
    }
}

module halfGrommet2() {
    w=topFlangeDia+bottomFlangeDia;
    height = wallDepth+topFlangeH+bottomFlangeH;
    
    difference() {
        grommet();
        translate([0, 0, -(height+wallDepth)/2]) cube(size=[w, w, height], center=true);
    }
    
}

if (cut == 0) {
    grommet();
} else if (cut == 1) {
    halfGrommet1();
} else if (cut == 2) {
    halfGrommet2();
}
