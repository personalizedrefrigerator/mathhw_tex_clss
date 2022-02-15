-- For use with LuaLaTeX

local lib = {}

function lib.makeFract(num, denom)
    -- Numerator and denominator should be integers
    assert(math.abs(math.floor(num) - num) < 0.01);
    assert(math.abs(math.floor(denom) - denom) < 0.01);

    local result =
    {
        simplify = function(self)
            for i = math.min(math.abs(self.num), math.abs(self.denom)),2,-1 do
                while self.num % i == 0 and self.denom % i == 0 do
                    self.num   = math.floor(self.num / i);
                    self.denom = math.floor(self.denom / i);
                end
            end
            return self;
        end,
        plusEql = function(self, other)
            local otherDenom = math.floor(other.denom);
            local otherNum   = math.floor(other.num);

            if self.denom ~= otherDenom then
                otherDenom = otherDenom * self.denom;
                otherNum   = otherNum * self.denom;
                self.num   = math.floor(self.num * other.denom);
                self.denom = math.floor(self.denom * other.denom);
            end

            self.num = math.floor(self.num + otherNum);
            return self;
        end,
        timesEql = function(self, other)
            self.num   = math.floor(self.num * other.num);
            self.denom = math.floor(self.denom * other.denom);
            return self;
        end,
        toAbs = function(self)
            self.num   = math.abs(self.num);
            self.denom = math.abs(self.denom);
            return self;
        end,
        negate = function(self)
            self.num = -self.num;
            return self;
        end,
        copy = function(self)
            return makeFract(self.num, self.denom);
        end,
        str = function(self)
            return "\\frac{" .. tostring(self.num) .. "}{" .. tostring(self.denom) .. "}";
        end,
        num = math.floor(num),
        denom = math.floor(denom)
    };

    return result;
end

math.round = function(number)
    return math.floor(number + 0.5)
end

function lib.exportMathLib()
    -- See https://stackoverflow.com/a/62932954
    for k,v in pairs(math) do
        if not _G[k] then
            _G[k] = v
        end
    end
end

function lib.colVec(values)
    local result = {
        plus = function(self, other)
            local res = {}

            for i,v in ipairs(self.vals) do
                res[i] = self.vals[i] + other.vals[i]
            end

            return lib.colVec(res)
        end,
        str = function(self)
            local res = "\\begin{pmatrix} "
            local isFirst = true

            for i,v in ipairs(self.vals) do
                if not isFirst then
                    res = res .. " \\\\ "
                end

                res = res .. tostring(v)
                isFirst = false
            end
            res = res .. " \\end{pmatrix}"

            return res
        end,
        vals = {},
    };

    for i,v in ipairs(values) do
        result.vals[i] = v
    end

    return result
end

function lib.commaSep(number, roundTo)
    roundTo = roundTo or 0
    local lThanZero = number < 0

    if lThanZero then
        number = - number
    end

    local fractional = math.round((number % 1) * roundTo) / (roundTo or 1)
    number = math.floor(number)

    if roundTo > 0 and fractional > 1.0 / roundTo then
        number = number + fractional
    end

    local result = "" .. tostring(number % 1000)
    local maxPower = math.floor(math.log(number)/math.log(10)/3 + 0.01)*3

    for i = 3,maxPower,3 do
        local c = (math.floor(number / math.pow(10, i)) % 1000)
        local s = tostring(c)

        while (string.len(result) + 1) % 4 ~= 0 do
            result = "0" .. result
        end

        result = s .. "," .. result
    end

    if lThanZero then
        result = '-' .. result
    end

    -- print(result)

    return result
end

function lib.runTests()
    -- Fraction tests.
    local f = lib.makeFract(30, 60);
    f:simplify();
    assert(f.num == 1);
    assert(f.denom == 2);

    f:plusEql(f);
    assert(f.num == 2 and f.denom == 2);

    local f2 = lib.makeFract(3, 4);
    f:plusEql(f2);
    f:simplify();
    assert(f.num == 7 and f.denom == 4);
    assert(f:str() == "\\frac{7}{4}");

    f:timesEql(lib.makeFract(2, 3));
    assert(f:str() == "\\frac{14}{12}");

    assert(lib.commaSep(123456789) == "123,456,789");
    assert(lib.commaSep(12) == "12");
    assert(lib.commaSep(1234) == "1,234");
    assert(lib.commaSep(-1000) == "-1,000");
    assert(lib.commaSep(1/3, 10) == "0.3");

    assert(lib.colVec({ 4, 2, 1}):str() == "\\begin{pmatrix} 4 \\\\ 2 \\\\ 1 \\end{pmatrix}")
end

lib.runTests();

function lib.binomTwo(a, b)
    local sprintFac = function(f, needsTail)
        if f > 1 then
            tex.sprint(f)
        end

        if f > 2 then
            tex.sprint("!");

            if needsTail then
                tex.sprint("\\ ");
            end
        elseif needsTail and f == 2 then
            tex.sprint("\\cdot ");
        end
    end

    tex.sprint("\\frac{");
    sprintFac(a, false);

    tex.sprint("}{");
    sprintFac(b, true);
    sprintFac(a - b, false);
    tex.sprint("}");
end

function lib.simplified(numer, denom)
    -- Prints a simplified version of numer over denom.
    local fract = makeFract(numer, denom);
    tex.sprint(fract:simplify():str());
end

lib.fract = lib.makeFract

return lib
