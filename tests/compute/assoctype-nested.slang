// assoctype-nested.slang

// Confirm that an associated type can be declared nested in its parent.

//TEST(compute):COMPARE_COMPUTE_EX:-slang -compute
//TEST(compute):COMPARE_COMPUTE_EX:-slang -compute -dx12
//TEST(compute, vulkan):COMPARE_COMPUTE_EX:-vk -compute

interface IRandomGenerator
{
	[mutating] int generateVal();
}

interface IRandomStrategy
{
	associatedtype Generator : IRandomGenerator;
	Generator makeGenerator(int seed);
}

int helper<T:IRandomStrategy>(T strategy, int seed)
{
	var generator = strategy.makeGenerator(seed);
	let val = generator.generateVal();
	return val;
}

struct CounterStrategy : IRandomStrategy
{
	struct Generator : IRandomGenerator
	{
		int state;
		[mutating] int generateVal()
		{
			return state++;
		}
	}

	Generator makeGenerator(int seed)
	{
		Generator generator = { seed };
		return generator;
	}
}

int test(int val)
{
	CounterStrategy strategy;
	return helper(strategy, val);
}

//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):dxbinding(0),glbinding(0),out
RWStructuredBuffer<int> gOutputBuffer;

[numthreads(4, 1, 1)]
void computeMain(uint3 dispatchThreadID : SV_DispatchThreadID)
{
	uint tid = dispatchThreadID.x;
	int inputVal = tid;
	int outputVal = test(inputVal);
	gOutputBuffer[tid] = outputVal;
}