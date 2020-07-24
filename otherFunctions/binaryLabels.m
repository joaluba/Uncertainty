function m_Labels = binaryLabels(v_Labels_temp,c_Classes)

m_Labels=zeros(length(v_Labels_temp), length(c_Classes));

for i=1:length(v_Labels_temp) 
    
%     for j=1:length(c_Classes) 
%         if v_Labels_temp(i)==c_Classes{j} 
%            m_Labels(i,j)=1;
%         end
%     end

m_Labels(i,v_Labels_temp(i)+1)=1;
end

    
end