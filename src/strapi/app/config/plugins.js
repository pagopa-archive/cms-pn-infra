module.exports = ({ env }) => ({
  // ...
  upload: {
    config: {
      provider: "strapi-provider-upload-aws-s3-advanced",
      providerOptions: {
        accessKeyId: env("AWS_ACCESS_KEY_ID"),
        secretAccessKey: env("AWS_ACCESS_SECRET"),
        region: env("AWS_REGION"),
        params: {
          bucket: env("AWS_BUCKET_NAME"), // or "Bucket", @aws-sdk requires capitalized properties, but the convention for this file is lowercased, but the plugin understands both
          // acl: env("AWS_BUCKET_ACL"), // or "ACL", see above
        },
        baseUrl: env("CDN_BASE_URL"), // e.g. "https://cdn.example.com", this is stored in strapi's database to point to the file
        prefix: env("BUCKET_PREFIX"), // e.g. "strapi-assets". If BUCKET_PREFIX contains leading or trailing slashes, they are removed internally to construct the URL safely
      },
    },
  },
  // ...
});