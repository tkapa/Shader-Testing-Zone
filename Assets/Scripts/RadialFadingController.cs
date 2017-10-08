using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RadialFadingController : MonoBehaviour {

    /// <summary>
    /// The Radial Fading Controller Class
    /// is intended to be used with the Radial Fading Shader
    /// 
    /// - Any object with the Radial Fading Shader as it's material
    ///     will be affected by this script
    ///     
    /// - Using the Radial Fading Controller and the Rect Fading Controller
    ///     at the same time in the same scene is not advised
    /// 
    /// </summary>

    [Range(0, 500)]
    [Tooltip("Determines the radius of terrain that is unaffected by the fade.")]
    public float minimumFadeRadius = 10.0f;

    [Range(0, 50)]
    [Tooltip("Determines how long the fade is.")]
    public float fadeLength = 5.0f;

    // Use this for initialization
    void Start () {
        if (FindObjectOfType<RadialFadingController>() || GetComponent<RadialFadingController>())
            Debug.Log("Detected a Rect Fading Controller on the scene!"
                + " Using both the Rect and Radial fading controller at the same time may cause unwanted results!");

        if (FindObjectsOfType<RadialFadingController>().Length > 1)
            Debug.Log("Detected another Radial Fading Controller on the scene!"
                + " Having two of the same faders at the same time will cause unwanted results");
    }
	
	// Update is called once per frame
	void Update () {

        //Sets all instances of these parameters
        Shader.SetGlobalVector("_CenterPos", transform.position);
        Shader.SetGlobalFloat("_MinRadius", minimumFadeRadius);
        Shader.SetGlobalFloat("_MaxRadius", minimumFadeRadius + fadeLength);
    }
}
