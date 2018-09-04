/**
 * @file DRMInterface.h
 * @brief Adobe Access iOS Interface
 * @version 5.11.60702
 * @date 2016/09/12:16:53:28
 *
 *
 *  @author ADOBE SYSTEMS INCORPORATED
 *  @copyright Copyright 2011-2014 Adobe Systems Incorporated. All Rights Reserved.
 *  
 *  NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
 *  terms of the Adobe license agreement accompanying it.  If you have received this file from a
 *  source other than Adobe, then your use, modification, or distribution of it requires the prior written
 *  permission of Adobe.
 *
 * @mainpage
 * DRMInterface.h
 * 
 * This header file declares the interfaces required to implement the Adobe Access subsystem. OEMs should expect to implement all of the interaces defined below. This implementation should be linked with the rest of the Adobe Access Porting Kit.
 *
 * This API should be considered preliminary and is subject to change before the final release.
 *
 * This API represents largely the same functionality as the ActionScript flash.net.drm API translated to Objective-C syntax and best practices.
 *
 * The key differences are:
 * 1. Removal of FMRMS 1.x support.
 * 2. Error and completion notifications replaced by callback blocks. The block parameters are used to make it easier to handle the results from a specific call, something that could be unclear in the AS3 model.
 * 3. Many class and method names have been changed to reflect their actual function better than the AS3 names.
 * 4. Many of the objects cannot be directly constructed. Those objects are only be constructed by private methods and retrieved from the public methods. This was actually true before, but it was not always clear.
 *
 * Caution - Although the specific classes and methods are expected to remain largely the same as described, there may be some changes in the final API. Do not rely on any internal implementation details of the library. Only the methods described in the DRMInterface.h will be supported in the future. 
 * This implementation uses the Adobe Test PKI DRM infrastructure. This ensures that any clients using it cannot be used with production licensing servers. Production PKI libraries will become available once implementation is finalized.
 *
 * For more information on using the sample video player, see the Adobe Access Objective-C API Readme document.
 *
 * @author ADOBE SYSTEMS INCORPORATED
 * @date 2016/09/12:16:53:28
 * @copyright Copyright 2011-2014 Adobe Systems Incorporated. All Rights Reserved.
 *
 *  NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
 *  terms of the Adobe license agreement accompanying it.  If you have received this file from a
 *  source other than Adobe, then your use, modification, or distribution of it requires the prior written
 *  permission of Adobe.
 */
#ifndef DRMINTERFACE_H
#define DRMINTERFACE_H

#include <Foundation/Foundation.h>


// ---------------- Start Declarations ----------------

@class DRMLicense;
@class DRMMetadata;
@class DRMLicenseDomain;
@class DRMPlaybackTimeWindow;

/// \class DRMSession This class must be retained for length of playback.
@class DRMSession;
@class DRMError;

@class AVURLAsset;

#pragma mark Declarations
typedef void (^DRMOperationError)(DRMError* error);
typedef void (^DRMOperationComplete)();
typedef void (^DRMPrepareForPlayback)();
typedef void (^DRMLicenseReturned)(NSUInteger numReturned);
typedef void (^DRMLicenseAcquired)(DRMLicense* license);

/// The prepare method must be called to enable content playback
typedef void (^DRMPlaylistUpdated)(NSURL* playlist, DRMMetadata* metadata, DRMPrepareForPlayback prepare);

typedef void (^DRMAssetUpdated)(AVURLAsset* asset, DRMMetadata* metadata, DRMPrepareForPlayback prepare);

typedef void (^DRMAuthenticationComplete)(NSData* authenticationToken);

typedef enum
{
	UNKNOWN = 0,
	ANONYMOUS = 1,
	USERNAME_AND_PASSWORD = 2
} DRMAuthenticationMethod;

typedef enum
{
	FORCE_REFRESH = 0, // The License is always downloaded from the media rights server.
	LOCAL_ONLY = 1,    // The License is only loaded from the local cache.
	ALLOW_SERVER = 2,  // The License is loaded from the local cache if possible, but otherwise is downloaded from the server.
} DRMAcquireLicenseSettings;

typedef enum
{
    LicenseServer = 0,
    IndivServer = 1,
    OtherServer = 2,
    DomainServer = 3
} DRMServerType;

/** Block definition of DRMRewriteServerURL.
    serverURL: the serverURL that need to be rewritten.
    serverType: server type. It can be license server, domain server, indiv server
 */
typedef NSString* (^DRMRewriteServerURL)(NSString* serverURL, DRMServerType serverType);


#pragma mark -
// ---------------- End Declarations ----------------

// ---------------- Start Interfaces ----------------
__attribute__((visibility("default")))
/**
 * This is the main entry point for Adobe Access DRM functionality. 
   The methods will execute the appropriate callback block on completion. 
   This class can only be constructed by sharedManager (DRMManager).
 */
@interface DRMManager : NSObject
	/** This property controls the maximum amount of time a DRM operation is allowed to take.
	 If the operation would take longer, it fails with a timeout error.
	 Note: This currently only applies to non-CPU related tasks.
     */
	@property(nonatomic, readwrite, getter=getMaxOperationTime, setter=setMaxOperationTime:) NSUInteger maxOperationTime;

    /** One DRMManager instance exists for each security domain.
     
     Returns the singleton DRMManager instance.
     */
	+(DRMManager*) sharedManager;

    -(void) setInitializationMetadata:(DRMMetadata*)metadata;

	// initializes DRM for faster playback
	-(void) initialize:(DRMOperationError)error complete:(DRMOperationComplete)complete;

    /** Set DRM Server URL rewrite callBack block. See the definition of DRMRewriteServerURL. 
        Instead of using the license server URL and domain server URL baked into the drmMetadata you can overwrite them with DRMRewriteServerURL block.
     */
    -(void) setDRMRewriteServerURL:(DRMRewriteServerURL)rewriteServerUrl;

    /** Sets the authentication token to use for communication with the specified server and domain. The token is cached automatically for the session, but you can use the setAuthenticationToken() method to manage tokens directly. Note: Setting NULL for the token value will clear the token held for this domain.
     */
	-(void) setAuthenticationToken:(DRMMetadata*)metadata authenticationDomain:(NSString*)authenticationDomain token:(NSData*)token error:(DRMOperationError)error complete:(DRMOperationComplete)complete;

    /** Authenticates a user. Listen for the DRMOperationComplete and DRMOperationError events to determine the outcome of the authentication attempt. Multiple authenticate() calls are queued. You can use a saved authentication token, or a token downloaded by another means, to establish an authenticated session with the media rights server in the future. To establish a session using a token, call the DRMManager setAuthenticationToken() method. The properties of the token, such as expiration date, are determined by the settings of the server that generates the token.
    */
    -(void) authenticate:(DRMMetadata*)metadata url:(NSString*)serverURL authenticationDomain:(NSString*)authenticationDomain username:(NSString*)username password:(NSString*)password error:(DRMOperationError)error complete:(DRMAuthenticationComplete)complete;

	/** This method simulates the license retrieval action. You can use this method to find out if you are entitled for a license.
        The license retrieved through this method cannot be used to playback content. It is useful when the user's computer doesn't 
        have the necessary output protection capabilities or necessary software to play content.
        Note: You do not need to specify the DRMPolicy to use as all policies are currently used */
	-(void) acquirePreviewLicense:(DRMMetadata*)contentData error:(DRMOperationError)error acquired:(DRMLicenseAcquired)acquired;

    /** Whenever a user plays protected content, AccessPlayer obtains and caches the license required to view the content. If the license is saved locally, and the license allows offline playback, the user can view the content without downloading the license again. Such local offline playback succeeds even if a connection to the Adobe Access server is not available.
    */
    -(void) acquireLicense:(DRMMetadata*)contentData setting:(DRMAcquireLicenseSettings)setting error:(DRMOperationError)error acquired:(DRMLicenseAcquired)acquired;

    /** You can preload the licenses required to play content protected by Adobe Access. Storing licenses allows you to access the downloaded license at any point of time. It is intended for use cases where a license can be shared between devices like in the case of domain licenses.
     */
    -(void) storeLicenseBytes:(NSData*)licenseBytes error:(DRMOperationError)error complete:(DRMOperationComplete)complete;

    /** You can remove the DRM data stored in your device by using this function. The application/user must download any required licenses again for the user to be able to access encrypted content. The DRM storage folder is located in the application sandbox under ~/Library/Private Documents/drm/ and is marked to not be synchronized to the cloud.*/
	-(void) resetDRM:(DRMOperationError)error complete:(DRMOperationComplete)complete;

    /** If the DRM metadata specifies that domain registration is required, then the AccessPlayer application can be used to join a license domain. This action triggers a domain registration request to be sent to the domain server. Once a license is issued to a license domain, the license can be exported and shared with other devices that have joined the license domain. Use forceRefresh to obtain the license from the license server even if the license is available locally.
     */
	-(void) joinLicenseDomain:(DRMLicenseDomain*)licenseDomain forceRefresh:(BOOL)forceRefresh error:(DRMOperationError)error complete:(DRMOperationComplete)complete;
	-(void) leaveLicenseDomain:(DRMLicenseDomain*)licenseDomain error:(DRMOperationError)error complete:(DRMOperationComplete)complete;

	/** Returns a boolean value indicating if the M3U8 file is valid. Note: This call will fail if the URL passed does not contain the string "faxs=1". */
	-(BOOL) isSupportedPlaylist:(NSURL*)url;

	/** !!! DO NOT USE WITH PSDK !!!
     Returns updated playlist and returns decryption session
     DRMSession returned must be released after video playback is complete
     The error callback may be called during the lifetime of the DRMSession
     The updated callback will be invoked when the playlist URI has been updated and for each metadata
       encountered in the m3u8.  In order to enable content decryption you must call the DRMPrepareForPlayback
       callback from your DRMPlaylistUpdated method
     The complete callback occurs when the license has been downloaded and content playback is ready
     NS_RETURNS_RETAINED means caller need to release the object. In case of ARC compiler will take care of it
     */
	-(DRMSession*) createSession:(NSURL*)playlistURL error:(DRMOperationError)error updated:(DRMPlaylistUpdated)updated complete:(DRMOperationComplete)complete NS_RETURNS_RETAINED;

    /// This is simular to createSession however uses the AVAssetResourceLoaderDelegate protocol.  The urlAsset must be constructed from a URL returned by getAssetPlaylistURL.
    -(DRMSession*) createAssetSession:(AVURLAsset*)urlAsset error:(DRMOperationError)error updated:(DRMAssetUpdated)updated complete:(DRMOperationComplete)complete NS_RETURNS_RETAINED;

    /// Will return the custom URL to play back protected content based on a given M3U8 url.  Use the URL returned when using createAssetSession.
    -(NSURL*) getAssetPlaylistURL:(NSURL*)url;

    -(void) returnLicense:(NSString*)serverURL licenseID:(NSString*)licenseID policyID:(NSString*)policyID immediateCommit:(BOOL)immediateCommit error:(DRMOperationError)error complete:(DRMLicenseReturned)complete;

    /// Force all DRM HTTP network requests to use HTTPS as the protocol scheme.
    -(void) forceHTTPS:(BOOL)forceHttps;

    /// Return whether we are currently forcing HTTPS as the DRM network protocol scheme.
    -(BOOL) isForcingHTTPS;

@end // DRMManager


__attribute__((visibility("default")))
/** The DRMMetadata class provides the information required to obtain the license necessary to view DRM-protected content. This is where the application developer can find out which policies are available and determine whether additional authentication is needed. The class can only be constructed by DRMManager or [DRMMetadata initFromNSData].
 */
@interface DRMMetadata : NSObject
    /// Returns the URL of a media rights server that provides the license that is required to view the associated content.
	@property(nonatomic, readonly, retain, getter=getServerUrl) NSString* serverUrl;

    /// Returns a unique ID identifying the content associated with this metadata on the media rights server.
	@property(nonatomic, readonly, retain, getter=getLicenseId) NSString* licenseId;

    /// Returns the DRMPolicy objects.
	@property(nonatomic, readonly, retain, getter=getPolicies) NSArray* policies;
	@property(nonatomic, readonly, retain, getter=getSHA1Hash) NSString* sha1Hash;
	@property(nonatomic, readonly, retain, getter=getCertId) NSString* certId;
	@property(nonatomic, readonly, getter=getManifestSigningRequired) BOOL manifestSigningRequired;
	- (id) initFromNSData:(NSData*)rawData error:(DRMOperationError)error;

@end // DRMMetadata

__attribute__((visibility("default")))
/// A DRMPolicy object presents the information that is required to successfully retrieve and consume a license, such as the type of authentication and the content domain of the media rights server.
/// This class describes a policy to use when acquiring a license. The class cannot be directly constructed by the application.
@interface DRMPolicy : NSObject
    /// A user-friendly string that you can use to refer to the specified VoucherAccessInfo object in the user interface.
    /// If the metadata file for a piece of media content has multiple licenses, each with its own DRMPolicy object, the
    /// user might need to decide which license to authenticate to. For example, you might have a subscription-level license
    /// with high privileges for viewing content, as well as a basic-level license with lower privileges. To distinguish between
    /// these two licenses, use the descriptive string in the displayName property. The string is set by the media packager tool
    /// (the tool that packages and encrypts media in preparation for distribution with a media rights server, such as Adobe Access).
	@property(nonatomic, readonly, retain, getter=getDisplayName) NSString* displayName;

    /// The supported types of authentication are ANONYMOUS and USERNAME_AND_PASSWORD.
    ///
    /// Returns the type of authentication required to obtain a license for the associated content.
	@property(nonatomic, readonly, getter=getAuthenticationMethod) DRMAuthenticationMethod authenticationMethod;

    /// Returns the content domain of the media rights server to which the user must be authenticated to obtain the license for the associated content.
    /// If authentication is to the default domain or no authentication is required, the value is null.
	@property(nonatomic, readonly, retain, getter=getAuthenticationDomain) NSString* authenticationDomain;

    /// Returns the content domain of the media rights server to which the user must be authenticated to obtain the license for the associated content.
    /// If authentication is to the default domain or no authentication is required, the value is null.
	@property(nonatomic, readonly, retain, getter=getLicenseDomain) DRMLicenseDomain* licenseDomain;
@end // DRMPolicy

__attribute__((visibility("default")))
/// A license domain signifies a group of playback devices that shares protected-content playback rights.
/// License domains allow an implementor to provide their own keys and supplemental authentication mechanisms to
/// tie together different Flash Access client instances into a single licensing group. This class captures the information
/// needed to allow the application to authenticate to a "domain" server and join a domain. The class cannot be directly constructed by the application.
@interface DRMLicenseDomain : NSObject
    /// The supported types of authentication are ANONYMOUS and USERNAME_AND_PASSWORD.
    ///
    /// Returns the type of authentication required to obtain a license for the associated content.
	@property(nonatomic, readonly, getter=getAuthenticationMethod) DRMAuthenticationMethod authenticationMethod;

    /// Returns the content domain of the media rights server to which the user must be authenticated to obtain the license
    /// for the associated content. If authentication is to the default domain or no authentication is required, the value is null.
	@property(nonatomic, readonly, retain, getter=getAuthenticationDomain) NSString* authenticationDomain;

    /// Returns the URL of the license domain.
	@property(nonatomic, readonly, retain, getter=getServerUrl) NSString* serverUrl;
	@property(nonatomic, retain, getter=getLicenseDomainName, setter=setLicenseDomainName:) NSString* name;
@end // DRMLicenseDomain

__attribute__((visibility("default")))
/// The DRMLicense class is a handle to the license token that allows a user to view DRM-protected content.
/// This class contains general and custom license information the application can use. The class cannot be directly constructed by the application.
@interface DRMLicense : NSObject
	// Returns the custom application-defined rights as NSString:NSData pairs, if any, defined by the customer when packaging the content.
	@property(nonatomic, readonly, retain, getter=getCustomProperties) NSDictionary* customProperties;

	/// Returns the beginning of this license's validity period. This is the fixed period during which the license can be used.
	@property(nonatomic, readonly, retain, getter=getLicenseStartDate) NSDate* licenseStartDate;

    /// Returns the date on which this license expires.
	@property(nonatomic, readonly, retain, getter=getLicenseEndDate) NSDate* licenseEndDate;

	/// This is the fixed period during which the license can be stored to disk. The date and time at which this license becomes valid for offline playback.
	@property(nonatomic, readonly, retain, getter=getOfflineStorageStartDate) NSDate* offlineStorageStartDate;

    /// The date and time at which this license expires for offline playback.
	@property(nonatomic, readonly, retain, getter=getOfflineStorageEndDate) NSDate* offlineStorageEndDate;

	/// This is the calculated period during which the license has been used and the maximum period allowed for usage The time period,
    /// after the first viewing, during which the associated content can be viewed or reviewed. The time period allotted for viewing
    /// begins when the user first views the content and ends after the allotted amount of time has elapsed. If no time is allotted,
    /// the value of the playbackTimeWindow property is null.
	@property(nonatomic, readonly, retain, getter=getPlaybackTimeWindow) DRMPlaybackTimeWindow* playbackTimeWindow;
	
	@property(nonatomic, readonly, retain, getter=getServerUrl) NSString* serverUrl;
	@property(nonatomic, readonly, retain, getter=getPolicyID) NSString* policyID;
	@property(nonatomic, readonly, retain, getter=getLicenseID) NSString* licenseID;

	- (NSData*) toNSData;
@end // DRMLicense

__attribute__((visibility("default")))
@interface DRMPlaybackTimeWindow : NSObject
    /// This is the playback window information from a particular license. This contains one piece of fixed data
    /// (the playback period) and two pieces of calculated data (start and end dates). The class cannot be directly constructed by the application.
	@property(nonatomic, readonly, getter=getPlaybackPeriodInSeconds) NSUInteger playbackPeriodInSeconds;

    /// The period of time during which a DRM license is valid (the playback window), in seconds.
	@property(nonatomic, readonly, retain, getter=getPlaybackStartDate) NSDate * playbackStartDate;

    /// The end date for the period of time during which a DRM license is valid (the playback window).
	@property(nonatomic, readonly, retain, getter=getPlaybackEndDate) NSDate * playbackEndDate;
@end // DRMPlaybackTimeWindow

__attribute__((visibility("default")))
@interface DRMError : NSObject
@property(nonatomic, readonly, getter=getMajorError) NSUInteger majorError;
@property(nonatomic, readonly,  getter=getMinorError) NSUInteger minorError;
@property(nonatomic, readonly, retain, getter=getPlatformError) NSError* platformError;
@property(nonatomic, readonly, retain, getter=getErrorString) NSString* errorString;
@end // DRMError

// ---------------- End Interfaces ----------------

#endif // DRMINTERFACE_H
