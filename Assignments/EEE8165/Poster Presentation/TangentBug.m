%% 2D Multi-Start Tangent Bug-Inspired Simulation
% Evaluates a mapless, range-based Tangent Bug-inspired local planner
% from four independent starting positions in a 2D obstacle course.
% Includes explicit goal-reach verification and print-ready formatting.

clear; clc; close all;

%% 1. Environment, Goal & Four Start Positions
goal_pos = [9.0, 8.6];

starts = [
    1.2, 1.0;   % Start 1: Bottom-left
    0.9, 6.8;   % Start 2: Top-left
    6.4, 1.1;   % Start 3: Bottom-right
    2.5, 3.6    % Start 4: Lower-mid interior
];
num_starts = size(starts, 1);

obstacles = {
    [4.0, 3.8;  5.8, 3.8;  5.8, 5.6;  4.0, 5.6], ... % Central Square
    [2.2, 6.4;  4.2, 6.4;  4.2, 7.6;  2.2, 7.6], ... % Upper-Left Block
    [6.6, 4.6;  8.3, 4.4;  7.5, 6.6]                 % Right Wedge
};

%% 2. Planner & Sensor Parameters
step_size  = 0.035;        % Integration step (m)
safety_buf = 0.24;         % Obstacle clearance buffer (m)
R_sensor   = 1.80;         % Local 360-deg range radius (m)
n_rays     = 240;          % Angular scan resolution (1.5 deg)
max_steps  = 3000;         % Step budget (max path = 105.0 m)

angles = linspace(-pi, pi, n_rays + 1);
angles(end) = [];

%% 3. Run Independent Tangent Bug-Inspired Planner from Each Start
paths       = cell(num_starts, 1);
reached     = false(num_starts, 1);
actual_lens = zeros(num_starts, 1);
direct_lens = zeros(num_starts, 1);
ratios      = zeros(num_starts, 1);

fprintf('--- 2D Multi-Start Tangent Bug-Inspired Verification ---\n');
for a = 1:num_starts
    [paths{a}, reached(a)] = runTangentBugInspired(starts(a, :), goal_pos, obstacles, ...
                                                   step_size, safety_buf, R_sensor, angles, max_steps);
    actual_lens(a) = sum(sqrt(sum(diff(paths{a}, 1, 1).^2, 2)));
    direct_lens(a) = norm(goal_pos - starts(a, :));
    ratios(a)      = actual_lens(a) / direct_lens(a);
    
    status_str = 'REACHED';
    if ~reached(a), status_str = 'TIMED OUT'; end
    fprintf('S_%d [%.1f, %.1f]: %s | Path = %.2f m | Direct = %.2f m | Ratio = %.2fx\n', ...
            a, starts(a,1), starts(a,2), status_str, actual_lens(a), direct_lens(a), ratios(a));
end

%% 4. High-Legibility Print Figure
fig = figure('Color', 'w', 'Position', [80, 80, 1080, 520]);
t = tiledlayout(1, 5, 'TileSpacing', 'loose', 'Padding', 'compact');

colors = [
    0.04, 0.52, 0.36;   % Start 1: Deep Emerald
    0.00, 0.44, 0.72;   % Start 2: Deep Blue
    0.80, 0.38, 0.00;   % Start 3: Dark Amber
    0.45, 0.16, 0.85    % Start 4: Deep Violet
];
markers = {'o', 's', '^', 'd'};

% --- LEFT PANEL: 2D Obstacle Course & Trajectories ---
ax1 = nexttile([1 3]);
hold(ax1, 'on'); box(ax1, 'on');
grid(ax1, 'on');
grid(ax1, 'minor');
set(ax1, 'FontName', 'Arial', 'FontSize', 12.5, 'FontWeight', 'bold', ...
         'LineWidth', 1.6, 'Layer', 'bottom', ...
         'GridColor', [0.55 0.60 0.68], 'GridAlpha', 0.65, ...
         'MinorGridColor', [0.75 0.78 0.84], 'MinorGridAlpha', 0.45);

% Direct Euclidean sightlines (dotted reference)
for a = 1:num_starts
    plot(ax1, [starts(a,1), goal_pos(1)], [starts(a,2), goal_pos(2)], ...
         ':', 'Color', [0.45 0.50 0.58], 'LineWidth', 1.5, 'HandleVisibility', 'off');
end

% Obstacles
for k = 1:length(obstacles)
    poly = obstacles{k};
    fill(ax1, poly(:,1), poly(:,2), [0.82 0.86 0.90], ...
         'EdgeColor', [0.12 0.16 0.22], 'LineWidth', 2.2, 'HandleVisibility', 'off');
end
fill(ax1, NaN, NaN, [0.82 0.86 0.90], 'EdgeColor', [0.12 0.16 0.22], ...
     'LineWidth', 2.2, 'DisplayName', 'Obstacles');

% Trajectories & Start Badges
label_offsets = [
    -0.58, -0.46;   % S1 offset
    -0.58,  0.50;   % S2 offset
     0.58, -0.42;   % S3 offset
    -0.62, -0.44    % S4 offset
];

for a = 1:num_starts
    p = paths{a};
    if reached(a)
        leg_txt = sprintf('S_%d (%.1f m)', a, actual_lens(a));
    else
        leg_txt = sprintf('S_%d (%.1f m - Cap)', a, actual_lens(a));
    end
    
    plot(ax1, p(:,1), p(:,2), '-', 'Color', colors(a,:), 'LineWidth', 3.4, ...
         'DisplayName', leg_txt);
     
    plot(ax1, starts(a,1), starts(a,2), markers{a}, 'MarkerSize', 11.5, ...
         'MarkerFaceColor', colors(a,:), 'MarkerEdgeColor', 'w', ...
         'LineWidth', 1.8, 'HandleVisibility', 'off');
     
    text(ax1, starts(a,1) + label_offsets(a,1), starts(a,2) + label_offsets(a,2), ...
         sprintf('S_%d', a), 'FontName', 'Arial', 'FontSize', 12.5, 'FontWeight', 'bold', ...
         'Color', colors(a,:), 'BackgroundColor', 'w', ...
         'EdgeColor', colors(a,:), 'LineWidth', 1.2, 'Margin', 2.5, ...
         'HorizontalAlignment', 'center');
end

% Goal Marker & Badge
plot(ax1, goal_pos(1), goal_pos(2), 'p', 'MarkerSize', 19, ...
     'MarkerFaceColor', [0.08 0.13 0.24], 'MarkerEdgeColor', 'w', ...
     'LineWidth', 1.6, 'DisplayName', 'Goal (T)');

text(ax1, goal_pos(1) + 0.58, goal_pos(2) - 0.15, 'T', ...
     'FontName', 'Arial', 'FontSize', 13, 'FontWeight', 'bold', ...
     'Color', [0.08 0.13 0.24], 'BackgroundColor', 'w', ...
     'EdgeColor', [0.08 0.13 0.24], 'LineWidth', 1.2, 'Margin', 2.5, ...
     'HorizontalAlignment', 'center');

title(ax1, 'A. 2D Multi-Start Trajectories', 'FontName', 'Arial', 'FontSize', 15, 'FontWeight', 'bold', 'Color', [0.08 0.13 0.24]);
xlabel(ax1, 'X Position (m)', 'FontName', 'Arial', 'FontSize', 13.5, 'FontWeight', 'bold');
ylabel(ax1, 'Y Position (m)', 'FontName', 'Arial', 'FontSize', 13.5, 'FontWeight', 'bold');
axis(ax1, 'equal');
xlim(ax1, [0 10.4]);
ylim(ax1, [0 9.8]);

lgd = legend(ax1, 'Location', 'southeast', 'NumColumns', 2, ...
             'FontName', 'Arial', 'FontSize', 11, 'FontWeight', 'bold');
lgd.Box = 'on';
lgd.LineWidth = 1.2;
lgd.EdgeColor = [0.45 0.50 0.58];

% --- RIGHT PANEL: Path Efficiency Ratio ---
ax2 = nexttile([1 2]);
hold(ax2, 'on'); box(ax2, 'on');
grid(ax2, 'on');
grid(ax2, 'minor');
set(ax2, 'FontName', 'Arial', 'FontSize', 12.5, 'FontWeight', 'bold', ...
         'LineWidth', 1.6, 'Layer', 'bottom', ...
         'GridColor', [0.55 0.60 0.68], 'GridAlpha', 0.65, ...
         'MinorGridColor', [0.75 0.78 0.84], 'MinorGridAlpha', 0.45);

b = bar(ax2, ratios, 0.54, 'FaceColor', 'flat', 'LineWidth', 1.4);
b.CData = colors;

yline(ax2, 1.0, '--', 'Color', [0.20 0.25 0.32], 'LineWidth', 2.0);

for a = 1:num_starts
    if reached(a)
        lbl = sprintf('%.2fx', ratios(a));
    else
        lbl = sprintf('%.2fx*', ratios(a));
    end
    text(ax2, a, ratios(a) + 0.03, lbl, 'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'bottom', 'FontName', 'Arial', 'FontSize', 12.5, ...
         'FontWeight', 'bold', 'Color', [0.08 0.13 0.24]);
end

set(ax2, 'XTick', 1:num_starts, 'XTickLabel', {'S_1', 'S_2', 'S_3', 'S_4'}, ...
         'FontName', 'Arial', 'FontSize', 13, 'FontWeight', 'bold');
xlim(ax2, [0.4, num_starts + 0.6]);
xlabel(ax2, 'Start Position', 'FontName', 'Arial', 'FontSize', 13.5, 'FontWeight', 'bold');
ylabel(ax2, 'Actual / Direct Length', 'FontName', 'Arial', 'FontSize', 13.5, 'FontWeight', 'bold');
title(ax2, 'B. Path Efficiency', 'FontName', 'Arial', 'FontSize', 15, 'FontWeight', 'bold', 'Color', [0.08 0.13 0.24]);
ylim(ax2, [0, max(ratios) * 1.28]);

%% ========================================================================
%% TANGENT BUG-INSPIRED PLANNER (Monotone-Progress Boundary Escape)
%% ========================================================================
function [path, reached] = runTangentBugInspired(start_pos, goal_pos, obstacles, step_size, safety_buf, R_sensor, angles, max_steps)
    pos        = start_pos;
    path       = pos;
    reached    = false;
    mode       = 'MOTION_TO_GOAL';
    d_reach    = norm(pos - goal_pos);
    follow_dir = 1;
    wall_steps = 0;
    n_rays     = length(angles);

    for step = 1:max_steps
        dist_to_goal = norm(pos - goal_pos);
        if dist_to_goal < 0.14
            path(end+1, :) = goal_pos; %#ok<AGROW>
            reached = true;
            break;
        end

        % 1. Local 360-deg Range Scan (No global map used)
        [ranges, hit_pts] = scanEnvironment(pos, obstacles, R_sensor, angles);
        [min_obs_d, min_idx] = min(ranges);

        % 2. Extract Local Tangent Graph (LTG) Range Discontinuities
        disc_idx = [];
        for i = 1:n_rays
            prev_i = mod(i - 2, n_rays) + 1;
            if abs(ranges(i) - ranges(prev_i)) > 0.30
                if ranges(i) < ranges(prev_i)
                    disc_idx(end+1) = i; %#ok<AGROW>
                else
                    disc_idx(end+1) = prev_i; %#ok<AGROW>
                end
            end
        end
        disc_idx = unique(disc_idx);

        goal_vec = goal_pos - pos;
        g_ang = atan2(goal_vec(2), goal_vec(1));
        [~, g_ray] = min(abs(atan2(sin(angles - g_ang), cos(angles - g_ang))));
        direct_clear = ranges(g_ray) >= min(R_sensor - 1e-3, dist_to_goal);

        % 3. Mode Execution
        if strcmp(mode, 'MOTION_TO_GOAL')
            if direct_clear && (min_obs_d > safety_buf * 1.05)
                move_dir = goal_vec / dist_to_goal;
                d_reach  = min(d_reach, dist_to_goal);
            elseif ~isempty(disc_idx)
                best_cost = inf; best_pt = [];
                for idx = disc_idx
                    cand_pt  = hit_pts(idx, :);
                    ray_dir  = [cos(angles(idx)), sin(angles(idx))];
                    perp_cw  = [ray_dir(2), -ray_dir(1)];
                    perp_ccw = [-ray_dir(2), ray_dir(1)];

                    next_i = mod(idx, n_rays) + 1;
                    if ranges(next_i) > ranges(idx)
                        offset_dir = perp_ccw;
                    else
                        offset_dir = perp_cw;
                    end
                    safe_cand = cand_pt + (safety_buf + 0.10) * offset_dir;
                    cost = norm(pos - safe_cand) + norm(safe_cand - goal_pos);
                    if cost < best_cost
                        best_cost = cost;
                        best_pt   = safe_cand;
                    end
                end

                % Enter boundary-following if too close to wall or heuristic stalls
                if (min_obs_d <= safety_buf * 1.05) || (best_cost > d_reach + 0.10)
                    mode = 'BOUNDARY_FOLLOW';
                    wall_steps = 0;
                    d_reach = min(d_reach, dist_to_goal);
                    t_vec = best_pt - pos;
                    cz = goal_vec(1)*t_vec(2) - goal_vec(2)*t_vec(1);
                    follow_dir = sign(cz); if follow_dir == 0, follow_dir = 1; end
                    move_dir = t_vec / norm(t_vec);
                else
                    d_reach  = min(d_reach, best_cost);
                    move_dir = (best_pt - pos) / norm(best_pt - pos);
                end
            else
                mode = 'BOUNDARY_FOLLOW';
                wall_steps = 0;
                d_reach = min(d_reach, dist_to_goal);
                move_dir = [-goal_vec(2), goal_vec(1)] / dist_to_goal;
            end
        else
            % Boundary-Following Mode: hug obstacle at safety_buf until clear progress
            wall_steps = wall_steps + 1;
            obs_dir = (hit_pts(min_idx, :) - pos) / max(norm(hit_pts(min_idx, :) - pos), 1e-6);
            if follow_dir > 0
                tangent = [-obs_dir(2), obs_dir(1)];
            else
                tangent = [obs_dir(2), -obs_dir(1)];
            end
            move_dir = tangent + 2.2 * (min_obs_d - safety_buf) * obs_dir;
            move_dir = move_dir / norm(move_dir);

            % Leave boundary ONLY when goal direction is unobstructed AND closer than d_reach
            goal_unit = goal_vec / dist_to_goal;
            moving_away_from_wall = dot(goal_unit, -obs_dir) > -0.15;
            if wall_steps > 10 && direct_clear && moving_away_from_wall && (dist_to_goal < d_reach - 0.10)
                mode = 'MOTION_TO_GOAL';
                d_reach = dist_to_goal;
            end
        end

        % 4. Hard Obstacle Clearance Guard
        [min_d_now, closest_pt_now] = nearestObstaclePoint(pos, obstacles);
        if min_d_now < safety_buf * 0.85
            push = (pos - closest_pt_now) / max(min_d_now, 1e-4);
            move_dir = (move_dir + 1.6 * push) / norm(move_dir + 1.6 * push);
        end

        pos = pos + step_size * move_dir;
        path(end+1, :) = pos; %#ok<AGROW>
    end
end

%% ========================================================================
%% GEOMETRY HELPERS
%% ========================================================================
function [ranges, hit_pts] = scanEnvironment(pos, obstacles, R_sensor, angles)
    n_rays = length(angles);
    ranges = R_sensor * ones(1, n_rays);
    hit_pts = pos + R_sensor * [cos(angles'), sin(angles')];
    for i = 1:n_rays
        ray_end = pos + R_sensor * [cos(angles(i)), sin(angles(i))];
        min_d = R_sensor;
        for k = 1:length(obstacles)
            poly = obstacles{k};
            n_v = size(poly, 1);
            for v = 1:n_v
                p1 = poly(v, :);
                p2 = poly(mod(v, n_v) + 1, :);
                [hit, pt] = segmentIntersect(pos, ray_end, p1, p2);
                if hit && norm(pt - pos) < min_d
                    min_d = norm(pt - pos);
                    hit_pts(i, :) = pt;
                end
            end
        end
        ranges(i) = min_d;
    end
end

function [min_d, closest_pt] = nearestObstaclePoint(pos, obstacles)
    min_d = inf;
    closest_pt = pos;
    for k = 1:length(obstacles)
        poly = obstacles{k};
        n_v = size(poly, 1);
        for v = 1:n_v
            a = poly(v, :);
            b = poly(mod(v, n_v) + 1, :);
            ab = b - a;
            t = max(0, min(1, dot(pos - a, ab) / dot(ab, ab)));
            proj = a + t * ab;
            d = norm(pos - proj);
            if d < min_d
                min_d = d;
                closest_pt = proj;
            end
        end
    end
end

function [intersect, pt] = segmentIntersect(p1, p2, p3, p4)
    intersect = false;
    pt = [NaN, NaN];
    r = p2 - p1; s = p4 - p3;
    denom = r(1)*s(2) - r(2)*s(1);
    if abs(denom) < 1e-10, return; end
    qp = p3 - p1;
    t = (qp(1)*s(2) - qp(2)*s(1)) / denom;
    u = (qp(1)*r(2) - qp(2)*r(1)) / denom;
    if t >= 0 && t <= 1 && u >= 0 && u <= 1
        intersect = true;
        pt = p1 + t * r;
    end
end