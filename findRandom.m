function model = findRandom(keys, values)
    temp = findAll(keys, values);
    number = length(temp);
    if number > 0
        index = randi(number);
        model = temp{index};
    else
        model = [];
    end
end