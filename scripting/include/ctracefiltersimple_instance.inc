#if defined _ctracefiltersimple_instance_included
 #endinput
#endif
#define _ctracefiltersimple_instance_included

#include <sourcescramble>

methodmap CTraceFilterSimple < MemoryBlock
{
	public native CTraceFilterSimple( int iPassEntity, int nCollisionGroup );
	public native bool ShouldHitEntity( int iEntity, int fContentsMask );
};

public SharedPlugin __pl_ctracefiltersimple_instance =
{
    name = "ctracefiltersimple_instance",
    file = "ctracefiltersimple_instance.smx",
#if defined REQUIRE_PLUGIN
    required = 1,
#else
    required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_ctracefiltersimple_instance_SetNTVOptional()
{
    MarkNativeAsOptional( "CTraceFilterSimple.CTraceFilterSimple" );
    MarkNativeAsOptional( "CTraceFilterSimple.ShouldHitEntity" );
}
#endif