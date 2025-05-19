clear all; 
close all;clc;

% [Markers,VideoFrameRate,AnalogSignals,AnalogFrameRate,Event,ParameterGroup,CameraInfo,ResidualError]=readC3D("Left_0001.c3d")
timestamp = readtable("Kicking_Events.csv")
timestamp.startFrame = timestamp.StartTime_s_ *200
timestamp.endFrame = timestamp.EndTime_s_ *200

timestamp_l = timestamp(1:5,:);
timestamp_r = timestamp(6:10,:);

function [p] = get3dPos(colName, data)
    varNames = fieldnames(data);   % 提取变量名，返回 cell 数组
    mainVar = data.(varNames{1});  
    p = mainVar.Trajectories.Labeled.Data(find(strcmp(colName,mainVar.Trajectories.Labeled.Labels)) ,1:3,:);
end


function [theta_deg_list] = vectorAngle(p1, p2, intersect)
    % p1 = get3dPos(p1Name,d);
    % p2 = get3dPos(p2Name,d);
    % intersect = get3dPos(intersectName,d);

    v1 = p1 - intersect;
    v2 = p2 - intersect;

    % 防止除以零
    theta_deg_list = [];
    for i=1:length(v1)
        costheta = (v1(:,:,i)*v2(:,:,i)')/(norm(v1(:,:,i))*norm(v2(:,:,i))); % 余弦值
        theta_deg = acos(costheta)*180/pi; % 夹角°
        theta_deg_list(end+1) = theta_deg;
    end
end

function [mid] = getMid(p1Name,p2Name, d)
    p1 = get3dPos(p1Name,d);
    p2 = get3dPos(p2Name,d);
    mid = (p1 + p2)/2;
end


data_left = ["Left_0001.mat", "Left_0002.mat","Left_0003.mat", "Left_0004.mat", "Left_0005.mat"];
data_right = ["Right_0001.mat", "Right_0002.mat","Right_0003.mat", "Right_0004.mat", "Right_0005.mat"];

spline_left = [];
spline_right = [];
spline_knee_left = [];
spline_knee_right = [];


for i=1:length(data_right)
    dl = load(data_left(i));
    dr = load(data_right(i));

    % add mid of ankel and knee and mtp 
    knee_l = getMid("FEME-L", "FELE-L", dl);
    knee_r = getMid("FEME-R", "FELE-R", dr);
    ankle_l = getMid("MALL-L","MALM-L", dl);
    ankle_r = getMid("MALL-R","MALM-R", dr);
    mtp_l = getMid("MTP1-L","MTP5-L",dl);
    mtp_r = getMid("MTP1-R","MTP5-R",dr);
    % iliac spine
    is_l = getMid("ASIS-L", "PSIS-L",dl);
    is_r = getMid("ASIS-R", "PSIS-R",dr);

    res1 = vectorAngle(knee_l, mtp_l , ankle_l);
    res2 = vectorAngle(knee_r, mtp_r , ankle_r);
    res3 = vectorAngle(ankle_l, is_l, knee_l);
    res4 = vectorAngle(ankle_r, is_r, knee_r);
    x_interval_l = timestamp_l{i,'endFrame'}- timestamp_l{i,'startFrame'};
    x_interval_r = timestamp_r{i,'endFrame'}- timestamp_r{i,'startFrame'};

    % ankle left
    spline_left = [spline_left; [res1(timestamp_l{i,'startFrame'}:timestamp_l{i,'endFrame'})]];
    spline_knee_left = [spline_knee_left; [res3(timestamp_l{i,'startFrame'}:timestamp_l{i,'endFrame'})]];
    % disp(timestamp_r{i,'startFrame'})
    % disp(timestamp_r{i,'endFrame'})
    % disp(size(res2(timestamp_r{i,'startFrame'}:timestamp_r{i,'endFrame'})))
    if i == 4
        spline_right = [spline_right; [res2(timestamp_r{i,'startFrame'}:timestamp_r{i,'endFrame'}+1)]];
        spline_knee_right = [spline_knee_right; [res4(timestamp_r{i,'startFrame'}:timestamp_r{i,'endFrame'}+1)]];
    else
        spline_right = [spline_right; [res2(timestamp_r{i,'startFrame'}:timestamp_r{i,'endFrame'})]];
        spline_knee_right = [spline_knee_right; [res4(timestamp_r{i,'startFrame'}:timestamp_r{i,'endFrame'})]];
    end
    figure(2);
    plot(res1(timestamp_l{i,'startFrame'}:timestamp_l{i,'endFrame'}));
    title("leftside original ankle angles");
    ylim([85,140]);
    hold on
    % figure(3);
    % p = polyfit(0:x_interval_l, res1(timestamp_l{i,'startFrame'}:timestamp_l{i,'endFrame'}), 3);       
    % y_fit = polyval(p, 0:x_interval_l);  
    % plot(0:x_interval_l,y_fit);
    % title("leftside polyfit ankle")
    % hold on
    % ankle right side
    figure(5);
    plot(res2(timestamp_r{i,'startFrame'}:timestamp_r{i,'endFrame'}));
    title("rightside original ankle angles");
    ylim([85,140]);
    hold on
    % figure(6);
    % p = polyfit(0:x_interval_r, res2(timestamp_r{i,'startFrame'}:timestamp_r{i,'endFrame'}), 3);       % 一次多项式拟合 => 线性拟合
    % y_fit = polyval(p, 0:x_interval_r);  
    % plot(0:x_interval_r,y_fit);
    % title("rightside polyfit ankle")
    % hold on
    % knee left 
    figure(7);
    plot(res3(timestamp_l{i,'startFrame'}:timestamp_l{i,'endFrame'}));
    title("leftside original knee angles");
    hold on
    % figure(8);
    % p = polyfit(0:x_interval_l, res3(timestamp_l{i,'startFrame'}:timestamp_l{i,'endFrame'}), 3);       
    % y_fit = polyval(p, 0:x_interval_l);  
    % plot(0:x_interval_l,y_fit);
    % title("leftside polyfit knee")
    % hold on
    % knee right
    figure(9);
    plot(res4(timestamp_r{i,'startFrame'}:timestamp_r{i,'endFrame'}));
    title("rightside original knee angles");
    hold on
    % figure(10);
    % p = polyfit(0:x_interval_r, res4(timestamp_r{i,'startFrame'}:timestamp_r{i,'endFrame'}), 3);       % 一次多项式拟合 => 线性拟合
    % y_fit = polyval(p, 0:x_interval_r);  
    % plot(0:x_interval_r,y_fit);
    % title("rightside polyfit knee")
    % hold on


end
figure(1);
xx = 0:x_interval_l;
ppl = spline(xx, mean(spline_left));
yyl = ppval(ppl,xx);
yyl_upper = mean(spline_left) + std(spline_left);
yyl_lower = mean(spline_left) - std(spline_left);
plot(xx, yyl, '-', "DisplayName","left mean", LineWidth= 2,COLOR = "blue");
hold on
fill([xx, fliplr(xx)], [yyl_upper, fliplr(yyl_lower)], 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none',"DisplayName","left std");
hold on
ppr = spline(xx, mean(spline_right));
yyr = ppval(ppr,xx);
yyr_upper = mean(spline_right) + std(spline_right);
yyr_lower = mean(spline_right) - std(spline_right);
plot(xx, yyr, '-', "DisplayName","right mean", LineWidth= 2, COLOR = "red");
hold on
fill([xx, fliplr(xx)], [yyr_upper, fliplr(yyr_lower)], 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none',"DisplayName","right std");
title("both sides with spline knee");
legend;


figure(4);
xx = 0:x_interval_l;
ppl = spline(xx, mean(spline_knee_left));
yyl = ppval(ppl,xx);
yyl_upper = mean(spline_knee_left) + std(spline_knee_left);
yyl_lower = mean(spline_knee_left) - std(spline_knee_left);
plot(xx, yyl, '-', "DisplayName","left mean", LineWidth= 2,COLOR = "blue");
hold on
fill([xx, fliplr(xx)], [yyl_upper, fliplr(yyl_lower)], 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none',"DisplayName","left std");
hold on
ppr = spline(xx, mean(spline_knee_right));
yyr = ppval(ppr,xx);
yyr_upper = mean(spline_knee_right) + std(spline_knee_right);
yyr_lower = mean(spline_knee_right) - std(spline_knee_right);
plot(xx, yyr, '-', "DisplayName","right mean", LineWidth= 2, COLOR = "red");
hold on
fill([xx, fliplr(xx)], [yyr_upper, fliplr(yyr_lower)], 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none',"DisplayName","right std");
title("both sides with spline ankle");
legend;
% 膝关节




% 看髋3d
% 
% x = squeeze(Left_0002.Trajectories.Labeled.Data(1,1,:));
% y = squeeze(Left_0002.Trajectories.Labeled.Data(1,2,:));
% z = squeeze(Left_0002.Trajectories.Labeled.Data(1,3,:));
% 
% x1 = squeeze(Left_0002.Trajectories.Labeled.Data(2,1,:));
% y1 = squeeze(Left_0002.Trajectories.Labeled.Data(2,2,:));
% z1 = squeeze(Left_0002.Trajectories.Labeled.Data(2,3,:));
% 
% plot3(x, y, z, Color = "black", LineWidth= 10)
% hold on
% plot3(x1, y1, z1,Color="red", LineWidth= 10)
% xlabel("front back")
% ylabel("left right")
% zlabel("up down")