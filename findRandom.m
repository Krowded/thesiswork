function model = findRandom(keys, values)
    temp = findAll(keys, values);
    index = randi(length(temp));
    model = temp{index};
end