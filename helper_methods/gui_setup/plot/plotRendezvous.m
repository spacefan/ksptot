function plotRendezvous(hAxis, timeArr, bodyInfo, iniOrbit, finOrbit, xfrOrbit, dv1, dv2, celBodyData)
%plotRendezvous Summary of this function goes here
%   Detailed explanation goes here

    gmuXfr = bodyInfo.gm;

    cla(hAxis, 'reset');

    iniOrbBodyInfo = getBodyInfoStructFromOrbit(iniOrbit);
    finOrbBodyInfo = getBodyInfoStructFromOrbit(finOrbit);

    axes(hAxis);
    hold on;
    axes(hAxis);
    set(hAxis,'XTickLabel',[]);
    set(hAxis,'YTickLabel',[]);
    set(hAxis,'ZTickLabel',[]);
    grid on;
    view(3);

    dRad = bodyInfo.radius;
    [X,Y,Z] = sphere(30);
    surf(dRad*X,dRad*Y,dRad*Z);
    colormap(bodyInfo.bodycolor);

    parentBodyInfo = bodyInfo.getParBodyInfo(celBodyData);

    [iniLB, iniUB, ~] = getOrbitTAPlotBnds(bodyInfo, parentBodyInfo, iniOrbit);
    [finLB, finUB, ~] = getOrbitTAPlotBnds(bodyInfo, parentBodyInfo, finOrbit);

    plotOrbit('r', iniOrbit(1), iniOrbit(2), iniOrbit(3), iniOrbit(4), iniOrbit(5), iniLB, iniUB, gmuXfr);
    plotOrbit('b', finOrbit(1), finOrbit(2), finOrbit(3), finOrbit(4), finOrbit(5), finLB, finUB, gmuXfr);
    plotOrbit('k', xfrOrbit(1), xfrOrbit(2), xfrOrbit(3), xfrOrbit(4), xfrOrbit(5), xfrOrbit(6), xfrOrbit(7), gmuXfr,[],[],[],'--');

    time1 = timeArr(1);
    time2 = timeArr(2);

    [iniRVectT1, ~] = getStateAtTime(iniOrbBodyInfo, time1, gmuXfr);
    [iniRVectT2, ~] = getStateAtTime(iniOrbBodyInfo, time2, gmuXfr);
    [finRVectT1, ~] = getStateAtTime(finOrbBodyInfo, time1, gmuXfr);
    [finRVectT2, ~] = getStateAtTime(finOrbBodyInfo, time2, gmuXfr);

    hold on;
    plot3(iniRVectT1(1),iniRVectT1(2),iniRVectT1(3),...
                    '-ro',...
                    'LineWidth',1.0,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','r',...
                    'MarkerSize',10);

    hold on;
    plot3(iniRVectT2(1),iniRVectT2(2),iniRVectT2(3),...
                    '-ro',...
                    'LineWidth',1.0,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','r',...
                    'MarkerSize',10);

    hold on;
    plot3(finRVectT1(1),finRVectT1(2),finRVectT1(3),...
                    '-bo',...
                    'LineWidth',1.0,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','b',...
                    'MarkerSize',10);

    hold on;
    plot3(finRVectT2(1),finRVectT2(2),finRVectT2(3),...
                    '-bo',...
                    'LineWidth',1.0,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','b',...
                    'MarkerSize',10);

    hold off;
    axis equal;

    drawnow;
end

