 [vertices, faces] = read_ply('frontwall.ply');
 
 mean1 = mean([vertices(52,:); vertices(54,:); vertices(30,:); vertices(31,:)]);
 vertices(52,:) = mean1;
 vertices(54,:) = mean1;
 vertices(30,:) = mean1;
 vertices(31,:) = mean1;
 
 mean2 = mean([vertices(51,:); vertices(53,:); vertices(27,:); vertices(28,:)]);
 vertices(51,:) = mean2;
 vertices(53,:) = mean2;
 vertices(27,:) = mean2;
 vertices(28,:) = mean2;
 
 write_ply(vertices, faces, 'test2.ply', 'ascii');