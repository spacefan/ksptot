function [bankAng,angOfAttack,angOfSideslip] = computeInertialAeroAnglesFromBodyAxes(ut, rVect, vVect, bodyInfo, bodyX, bodyY, bodyZ)
    %Source: http://www.dept.aoe.vt.edu/~cdhall/courses/aoe5204/AircraftMotion.pdf

    [R_wind_2_inert, ~, ~, ~] = computeWindFrame(rVect,vVect);
    Rtotal = horzcat(bodyX, bodyY, bodyZ);
    
    angles = rotm2eul(R_wind_2_inert' * Rtotal, 'xyz');

    bankAng = angles(1);
	angOfAttack = angles(2);
	angOfSideslip = angles(3);
     
    bankAng = real(bankAng);
    angOfAttack = real(angOfAttack);
    angOfSideslip = real(angOfSideslip);
end