clear all; 
close all;
clc;

% data preprocessing

function [data] = getEmgFromChannel(colnum, data, start_idx, end_idx)
    varNames = fieldnames(data);   % 提取变量名，返回 cell 数组
    mainVar = data.(varNames{1});  
    data = mainVar.Analog.Data(colnum, start_idx:end_idx);
end

function [startid, endid] = getRangeIdx(filename,store)
    row = store(find(strcmp(filename,store.FileName)),:);
    startid = row.StartFrame;
    endid = row.EndFrame;
end

function emg_interp=interpolation(stride_signal)
    % emg interpolation 0-100% of 1 stride cyle
    % 插值为 101 个点（代表 0% 到 100%）
    stride_length = length(stride_signal);
    emg_interp = interp1(1:stride_length, stride_signal, 0:0.1:100, 'spline');
end;

function emg_smooth = root_mean_square(data)
    window = 10; % 滑动窗口长度
    emg_smooth = sqrt(movmean(data.^2, window));  
end;

function ans = draw(data,method)
    ans = [];
    if method == "abs"
        ans = abs(data);
    elseif method == "rms"
        % for d=1:length(data(:,1))
        %     ans = [ans; root_mean_square(data(d,:))];
        % end
        ans = sqrt(movmean(data.^2, 10, 2));
    elseif method == "ma"
        for d=1:length(data(:,1))
            %     window = 10;
            ans = [ans; movmean(data(d,:),10)];
        end
    elseif method == "std"
        for d=1:length(data(1,:))
            ans = [ans, std(data(:,d))];
        end
    elseif method == "mean"
        for d=1:length(data(1,:))
            ans = [ans, mean(data(:,d))];
        end
    end

end;

strides = readtable("data/Stride_Frames.csv");
nw17_store = [];
wl17_store = [];
wr17_store = [];
nw18_store = [];
wl18_store = [];
wr18_store = [];
for i = 1:5
    % % no weight force
    % nw = readtable("data/No_Weight_000"+i+"_Total_Force_Filtered.csv");
    % figure(1);
    % plot3(nw.TotalForceInX,nw.TotalForceInY,nw.TotalForceInZ);
    % hold on;
    % % weight left force
    % wl = readtable("data/Weight_Left_000"+i+"_Total_Force_Filtered.csv");
    % figure(2);
    % plot3(wl.TotalForceInX,wl.TotalForceInY,wl.TotalForceInZ);
    % hold on;
    % % weight right force
    % wr = readtable("data/Weight_Right_000"+i+"_Total_Force_Filtered.csv");
    % figure(3);
    % plot3(wr.TotalForceInX,wr.TotalForceInY,wr.TotalForceInZ);
    % hold on;
    % emg no weight
    nw_emg = load("data/No_Weight_000"+i+".mat");
    % figure(4);
    [s,e] = getRangeIdx("No_Weight_000"+i+".mat", strides);
    % 17
    nw17 = getEmgFromChannel(14,nw_emg,s,e);
    % 18
    nw18 = getEmgFromChannel(15,nw_emg,s,e);
    nw17 = interpolation(nw17);
    nw18 = interpolation(nw18);
    nw17_store = [nw17_store; nw17];
    nw18_store = [nw18_store; nw18];
    % plot(nw17);
    % hold on;
    % plot(nw18);
    % hold on;
    % emg left 
    wl_emg = load("data/Weight_Left_000"+i+".mat");
    % figure(5);
    [s,e] = getRangeIdx("Weight_Left_000"+i+".mat", strides);
    % 17
    wl17 = getEmgFromChannel(14,wl_emg,s,e);
    % 18
    wl18 = getEmgFromChannel(15,wl_emg,s,e);
    wl17 = interpolation(wl17);
    wl18 = interpolation(wl18);
    % hold on;
    wl17_store = [wl17_store; wl17];
    wl18_store = [wl18_store; wl18];
    % emg right
    wr_emg = load("data/Weight_Right_000"+i+".mat");
    % figure(6);
    [s,e] = getRangeIdx("Weight_Right_000"+i+".mat", strides);
    % 17
    wr17 = getEmgFromChannel(14,wr_emg,s,e);
    % 18
    wr18 = getEmgFromChannel(15,wr_emg,s,e);
    wr17 = interpolation(wr17);
    wr18 = interpolation(wr18);
    % hold on;
    wr17_store = [wr17_store; wr17];
    wr18_store = [wr18_store; wr18];
end

store = cat(3, nw17_store, wl17_store, wr17_store, nw18_store, wl18_store, wr18_store);
titles = ["NoWeightAbs", "LeftWeightAbs", "RightWeightAbs","NoWeightLumbarErector", "LeftWeightLumbarErector", "RightWeightLumbarErector"];
group_n = [];
group_l = [];
group_r = [];
for i = 1:length(store(1,1,:))
    s = store(:,:,i);
    % absolute value rectification
    abs_res = draw(s, "abs");
    % emg smoothing (root mean square)
    rms_res = draw(abs_res, "rms");
    % std & mean 1->5
    std_res = draw(rms_res, "std");
    mean_res = draw(rms_res, "mean");
    if i > 3
        if mod(i,3) == 1
            group_n = [group_n; mean_res];
        end
        if mod(i,3) == 2
            group_l = [group_l; mean_res];
        end
        if mod(i,3) == 0
            group_r = [group_r; mean_res];
        end
    end
   
    if i <= 3
        figure(1);
        title("Abs");
    else
        figure(2);
        title("LumbarErector");
    end;

    h1 = plot(0:0.1:100, mean_res,"DisplayName",titles(i));    
    hold on;
    x = 0:0.1:100;
    h2 = fill([x, fliplr(x)],[mean_res+std_res, fliplr(mean_res-std_res)],'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none',"DisplayName",titles(i)+" +-std");   
    ylim([0,0.5]);
    hold on;
        % title(titles(i) + " MEAN");
    xtickformat('percentage');
    legend show;
    % figure(i*3 + 1);
    % h3 = plot(1:1000,rms_res);
    % title(titles(i) + " RMS");
    % ylim([0,0.4]);
    % figure(i*3 + 2);
    % hold on;
    % title(titles(i) + " ABS");
    % h4 = plot(1:1000,abs_res);
    % ylim([0,0.5]);
end


% hypothesis test right > left > upload anova

% forming labels

group = [ 
    repmat({'Right'}, 1, length(group_r)), ...
    repmat({'Left'},  1, length(group_l)), ...
    repmat({'None'},  1, length(group_n)) 
];

[p, tbl, stats] = anova1([group_r,group_l,group_n], group);
% [p, tbl, stats] = anova1([group_r,group_l], group);

disp(['p-value = ', num2str(p)]);
% 可选：多重比较（查看哪组显著不同）
figure;
multcompare(stats);