module.exports = ({ env }) => ({
  // ...
  upload: {
    config: {
      provider: "strapi-provider-aws-s3-cloudfront-cdn",
      providerOptions: {
        accessKeyId: env("AWS_ACCESS_KEY_ID"),
        secretAccessKey: env("AWS_ACCESS_SECRET"),
        region: env("AWS_REGION"),
        params: {
          Bucket: env("AWS_BUCKET"),
        },
        cdn: env("CDN_BASE_URL"), // eg. https://xyz.cloudfront.net (no trailing slash)
      },
      actionOptions: {
        upload: {},
        uploadStream: {},
        delete: {},
      },
    },
  },
  // ...
});