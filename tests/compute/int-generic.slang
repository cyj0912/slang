//TEST(compute):COMPARE_COMPUTE:
//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):dxbinding(0),glbinding(0),out
//TEST_INPUT:type Material<1,2>
RWStructuredBuffer<int> outputBuffer;

interface IBRDF
{
    int compute();
};

interface IMaterial
{
    associatedtype TBRDF : IBRDF;
    TBRDF getBRDF();
}

struct BRDF<let A:int, let B:int> : IBRDF
{
    int c;
    int compute()
    {
        return A+B;        
    }
};

struct Material<let A:int, let B: int> : IMaterial
{
    typedef BRDF<A,B> TBRDF;
    TBRDF getBRDF() { TBRDF a; a.c = 0; return a; }
};

[numthreads(1, 1, 1)]
void computeMain<M : IMaterial>(
    uniform M material,
    uint3 dispatchThreadID : SV_DispatchThreadID)
{
    M.TBRDF brdf = material.getBRDF();
	int outVal = brdf.compute();
	outputBuffer[dispatchThreadID.x] = outVal;
}