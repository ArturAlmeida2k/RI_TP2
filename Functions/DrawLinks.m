function h = DrawLinks(Org)

%h = plot3(Org(1,:),Org(2,:),Org(3,:),"b", "LineWidth", 4, "MarkerSize", 5);

% ou

h = line(Org(1,:),Org(2,:),Org(3,:));
h.LineWidth = 3;
h.Marker = "o";
h.MarkerSize = 4;

if size(Org,2) == 3
    h.MarkerIndices = 2:3;
end

if size(Org,2) > 3
    h.MarkerIndices = 1:size(Org, 2)-1;
end

end