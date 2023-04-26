#include <sourcemod>
#include <sdktools>

#define REQUIRE_EXTENSIONS
#include <sourcescramble>

#define GAMEDATA_FILE 	"ctracefiltersimple_instance"

Address g_addrCTraceFilterSimple_vtable = Address_Null;

Handle g_hSDKVCall_CTraceFilterSimple_ShouldHitEntity = null;

// struct CTraceFilterSimple
// {
// 	/* 0 */ void *__vptr;
// 	/* 4 */ const IHandleEntity *m_pPassEnt;
// 	/* 8 */ int m_collisionGroup;
// 	/* 12 */ ShouldHitFunc_t m_pExtraShouldHitCheckFunction;
// }

public any Native_CTraceFilterSimple_CTraceFilterSimpleInstance( Handle hPlugin, int nParams )
{
	int iPassEntity = GetNativeCell( 1 );
	int nCollisionGroup = GetNativeCell( 2 );

	MemoryBlock hTraceFilter = new MemoryBlock( 0x10 );
	StoreToAddress( hTraceFilter.Address, g_addrCTraceFilterSimple_vtable, NumberType_Int32 );

	Address addrPassEntity = ( iPassEntity != INVALID_ENT_REFERENCE ) ? GetEntityAddress( iPassEntity ) : Address_Null;

	hTraceFilter.StoreToOffset( 4, view_as< int >( addrPassEntity ), NumberType_Int32 );		// const IHandleEntity *passentity
	hTraceFilter.StoreToOffset( 8, nCollisionGroup, NumberType_Int32 );						// int collisionGroup
	hTraceFilter.StoreToOffset( 12, 0, NumberType_Int32 );								// ShouldHitFunc_t pExtraShouldHitCheckFn

	return CloneHandle( hTraceFilter );
}

public any Native_CTraceFilterSimple_ShouldHitEntity( Handle hPlugin, int nParams )
{
	Address addrTraceFilter = view_as< MemoryBlock >( GetNativeCell( 1 ) ).Address;
	int iEntity = GetNativeCell( 2 );
	int fContentsMask = GetNativeCell( 3 );

	return SDKCall( g_hSDKVCall_CTraceFilterSimple_ShouldHitEntity, addrTraceFilter, iEntity, fContentsMask );
}

public void OnPluginStart()
{
	GameData hGameData = new GameData( GAMEDATA_FILE );

	if ( hGameData == null )
	{
		SetFailState( "Unable to load gamedata file \"" ... GAMEDATA_FILE ... "\"" );
	}

	g_addrCTraceFilterSimple_vtable = hGameData.GetAddress( "CTraceFilterSimple vtable" );

	if ( g_addrCTraceFilterSimple_vtable == Address_Null )
	{
		delete hGameData;

		SetFailState( "Unable to find gamedata address entry or signature in binary for \"CTraceFilterSimple vtable\"" );
	}

	// bool CTraceFilterSimple::ShouldHitEntity( IHandleEntity *pHandleEntity, int contentsMask )
	StartPrepSDKCall( SDKCall_Raw );
	PrepSDKCall_SetVirtual( 0 );
	PrepSDKCall_SetReturnInfo( SDKType_Bool, SDKPass_Plain );
	PrepSDKCall_AddParameter( SDKType_CBaseEntity, SDKPass_Pointer, VDECODE_FLAG_ALLOWNULL | VDECODE_FLAG_ALLOWWORLD );
	PrepSDKCall_AddParameter( SDKType_PlainOldData, SDKPass_Plain );
	g_hSDKVCall_CTraceFilterSimple_ShouldHitEntity = EndPrepSDKCall();
}

public APLRes AskPluginLoad2( Handle hMyself, bool bLate, char[] szError, int nErrMax )
{
	RegPluginLibrary( "ctracefiltersimple_instance" );

	CreateNative( "CTraceFilterSimple.CTraceFilterSimple", Native_CTraceFilterSimple_CTraceFilterSimpleInstance );
	CreateNative( "CTraceFilterSimple.ShouldHitEntity", Native_CTraceFilterSimple_ShouldHitEntity );

	return APLRes_Success;
}

public Plugin myinfo =
{
	name = "[ANY] CTraceFilterSimple Instance",
	author = "Justin \"Sir Jay\" Chellah",
	description = "Allows developers to create an instance of the game's CTraceFilterSimple filter class for ray casts",
	version = "2.0.0",
	url = "https://justin-chellah.com"
};