// modern-syntax.slang
//TEST(compute):COMPARE_COMPUTE_EX:-slang -compute

// This file exists to confirm that declarations using "modern"
// syntax are handled correctly by the compiler front-end.

typealias MyInt = int;

func test(val: MyInt) -> MyInt
{
	var tmp = val;
	let c : MyInt = 16;
	tmp += c;
	return tmp;
}

//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):dxbinding(0),glbinding(0),out
RWStructuredBuffer<int> outputBuffer;

[numthreads(4, 1, 1)]
void computeMain(uint3 dispatchThreadID : SV_DispatchThreadID)
{
	uint tid = dispatchThreadID.x;
	int val = test(tid);
	outputBuffer[tid] = val;
}