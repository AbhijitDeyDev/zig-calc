pub const CalcState = struct {
    result: usize,
    operation: u8,
    input: usize,


    pub fn init() CalcState {
        return CalcState{ .result = 0, .operation = '~', .input = 0 };
    }

    pub fn updateInput(self: *CalcState, _input: usize) void {
        self.input = _input;
    }
    pub fn updateOpetation(self: *CalcState, _opeation: u8) void {
        self.operation = _opeation;
    }
};

pub const MouseClickData = struct {
    clicked: bool,
    x: i32,
    y: i32,

    pub fn init(clicked: bool, x: i32, y: i32) MouseClickData {
        return MouseClickData{ .clicked = clicked, .x = x, .y = y };
    }
};

pub const LabelRect = struct {
    x: c_int,
    y: c_int,
    label_size: c_int,
};

pub const ButtonRect = struct {
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    label_size: c_int,
};
